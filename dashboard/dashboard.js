/**
 * dashboard.js — Shell interactivity, notification bell controller, and Pusher real-time handler.
 */

const API = '../database';

async function postJSON(url, body = {}) {
  try {
    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      credentials: 'same-origin',
      body: JSON.stringify(body),
    });
    return await res.json();
  } catch {
    return { success: false, message: 'Network error.' };
  }
}

function closeModal(overlayId) {
  document.getElementById(overlayId)?.classList.remove('show');
}

/* -------------------------------------------------------------------------
 * NOTIFICATION BELL & REAL-TIME SYSTEM (With Read State & Dynamic Time Ago)
 * ------------------------------------------------------------------------- */
let unreadCount = 0;
let notificationItems = [];
let liveNotifications = [];
let notificationLoadPromise = null;
let notificationLoading = false;
let notificationLoadError = '';
let markReadAfterLoad = false;

function notificationCacheKey() {
  const userId = window.RETRIEVA_USER_ID ?? document.body?.dataset?.userId;
  return userId === undefined || userId === null || userId === ''
    ? ''
    : `retrieva:notifications:v1:${userId}`;
}

function clearCachedNotifications() {
  const key = notificationCacheKey();
  if (!key) return;
  try {
    sessionStorage.removeItem(key);
  } catch (error) {
    console.warn('Saved notifications could not be cleared.', error);
  }
}

function normalizeNotification(notification) {
  if (!notification || typeof notification !== 'object'
      || typeof notification.title !== 'string'
      || typeof (notification.body ?? notification.message) !== 'string') {
    return null;
  }

  return {
    id: notification.id === undefined || notification.id === null || notification.id === ''
      ? null
      : String(notification.id),
    category: typeof notification.category === 'string' ? notification.category : 'system',
    title: notification.title,
    body: notification.body ?? notification.message,
    entity_type: notification.entity_type ?? null,
    entity_id: notification.entity_id ?? null,
    read_at: notification.read_at || null,
    created_at: typeof notification.created_at === 'string' ? notification.created_at : new Date().toISOString(),
    type: typeof notification.type === 'string' ? notification.type : '',
  };
}

function readCachedNotifications() {
  const key = notificationCacheKey();
  if (!key) return [];
  try {
    const cached = JSON.parse(sessionStorage.getItem(key) || 'null');
    return Array.isArray(cached?.notifications)
      ? cached.notifications.map(normalizeNotification).filter(Boolean)
      : [];
  } catch (error) {
    console.warn('Saved notifications could not be read.', error);
    return [];
  }
}

function cacheNotifications() {
  const key = notificationCacheKey();
  if (!key) return;
  try {
    sessionStorage.setItem(key, JSON.stringify({
      notifications: notificationItems,
      savedAt: Date.now(),
    }));
  } catch (error) {
    console.warn('Notifications could not be saved for this tab.', error);
  }
}

function mergeNotifications(...groups) {
  const byId = new Map();
  const withoutId = [];
  groups.flat().forEach((value) => {
    const item = normalizeNotification(value);
    if (!item) return;
    if (item.id === null) {
      withoutId.push(item);
    } else {
      byId.set(item.id, item);
    }
  });
  return [...byId.values(), ...withoutId]
    .sort((a, b) => {
      const aTime = new Date(a.created_at.replace(' ', 'T')).getTime();
      const bTime = new Date(b.created_at.replace(' ', 'T')).getTime();
      return (Number.isNaN(bTime) ? 0 : bTime) - (Number.isNaN(aTime) ? 0 : aTime);
    })
    .slice(0, 30);
}

function renderNotifications() {
  const notifList = document.getElementById('notif-list');
  if (notifList) {
    notifList.replaceChildren();
    if (notificationLoadError) {
      const error = document.createElement('div');
      error.className = 'notif-error';
      error.setAttribute('role', 'status');
      error.textContent = notificationItems.length
        ? 'Could not refresh notifications. Showing saved results.'
        : 'Notifications could not be loaded.';
      const retry = document.createElement('button');
      retry.type = 'button';
      retry.className = 'notif-retry';
      retry.dataset.retryNotifications = 'true';
      retry.textContent = 'Retry';
      error.appendChild(retry);
      notifList.appendChild(error);
    }

    if (notificationItems.length === 0) {
      if (!notificationLoadError) {
        const empty = document.createElement('div');
        empty.className = 'notif-empty';
        empty.setAttribute('aria-live', 'polite');
        empty.textContent = notificationLoading ? 'Loading notifications…' : 'No new notifications';
        notifList.appendChild(empty);
      }
    } else {
      notificationItems.forEach((notification) => {
        const isUnread = !notification.read_at;
        const type = notification.type || (notification.category === 'claim' ? 'warning' : 'info');
        const item = document.createElement('div');
        item.className = `notif-item ${isUnread ? 'notif-item--unread' : ''}`;
        if (notification.id !== null) item.dataset.notificationId = notification.id;
        item.dataset.timestamp = notification.created_at.replace(' ', 'T');
        item.innerHTML = `
          <div class="notif-item__icon">${getNotifIcon(type)}</div>
          <div class="notif-item__content">
            <strong>${escapeHtml(notification.title)}</strong>
            <p>${escapeHtml(notification.body)}</p>
            <small class="time-ago">${formatTimeAgo(item.dataset.timestamp)}</small>
          </div>
        `;
        notifList.appendChild(item);
      });
    }
  }

  unreadCount = notificationItems.filter((notification) => !notification.read_at).length;
  updateBadge();
}

function initNotifications() {
  const bellBtn = document.getElementById('notif-bell-btn');
  const dropdown = document.getElementById('notif-dropdown');
  const clearBtn = document.getElementById('notif-clear-btn');
  const notifList = document.getElementById('notif-list');

  if (!bellBtn || !dropdown) return;

  notificationItems = mergeNotifications(readCachedNotifications(), notificationItems);
  notificationLoading = notificationItems.length === 0;
  renderNotifications();
  loadStoredNotifications();

  setInterval(updateTimeAgoDisplay, 30000);

  bellBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    const isHidden = dropdown.hidden;
    dropdown.hidden = !isHidden;
    bellBtn.setAttribute('aria-expanded', !isHidden);
    
    document.getElementById('user-menu-dropdown')?.classList.remove('show');

    // Mark notifications as read and clear badge when dropdown is opened
    if (isHidden && unreadCount > 0) {
      markAllAsRead();
    } else if (isHidden && notificationLoading) {
      markReadAfterLoad = true;
    }
  });

  dropdown.addEventListener('click', (e) => e.stopPropagation());
  notifList?.addEventListener('click', (event) => {
    if (event.target.closest('[data-retry-notifications]')) {
      loadStoredNotifications();
    }
  });

  document.addEventListener('click', () => {
    dropdown.hidden = true;
    bellBtn.setAttribute('aria-expanded', 'false');
  });

  clearBtn?.addEventListener('click', async () => {
    if (notificationLoadPromise) await notificationLoadPromise;
    const previousItems = notificationItems;
    notificationItems = [];
    liveNotifications = [];
    notificationLoadError = '';
    cacheNotifications();
    renderNotifications();

    const result = await postJSON(`${API}/notifications.php`, { action: 'clear' });
    if (!result.success) {
      notificationItems = mergeNotifications(previousItems, liveNotifications);
      notificationLoadError = result.message || 'Notifications could not be cleared.';
      cacheNotifications();
      renderNotifications();
      showToast('Notifications not cleared', notificationLoadError, 'danger');
      return;
    }
    cacheNotifications();
  });
}

function loadStoredNotifications() {
  if (notificationLoadPromise) return notificationLoadPromise;
  notificationLoading = notificationItems.length === 0;
  notificationLoadError = '';
  renderNotifications();
  notificationLoadPromise = (async () => {
    try {
      const res = await fetch(`${API}/notifications.php`, {
        credentials: 'same-origin',
        cache: 'no-store',
      });
      if (!res.ok) throw new Error(`Notification request failed with status ${res.status}.`);
      const data = await res.json();
      if (!data.success || !Array.isArray(data.notifications)) {
        throw new Error(data.message || 'The notification response was invalid.');
      }

      const stored = data.notifications.map(normalizeNotification).filter(Boolean);
      notificationItems = mergeNotifications(stored, liveNotifications);
      liveNotifications = [];
      notificationLoadError = '';
      cacheNotifications();
    } catch (error) {
      notificationLoadError = 'Could not refresh notifications. Try again.';
      console.error('Notification refresh failed.', error);
    } finally {
      notificationLoading = false;
      notificationLoadPromise = null;
      renderNotifications();
      const dropdown = document.getElementById('notif-dropdown');
      if (markReadAfterLoad) {
        const shouldMarkRead = dropdown && !dropdown.hidden && unreadCount > 0;
        markReadAfterLoad = false;
        if (shouldMarkRead) markAllAsRead();
      }
    }
  })();
  return notificationLoadPromise;
}

function addNotification(title, message, type = 'info', metadata = {}) {
  const notification = normalizeNotification({
    ...metadata,
    title: String(title || 'Notification'),
    message: String(message || ''),
    type,
    read_at: null,
    created_at: new Date().toISOString(),
  });
  if (!notification) return;
  liveNotifications = mergeNotifications(liveNotifications, [notification]);
  notificationItems = mergeNotifications([notification], notificationItems);
  notificationLoadError = '';
  cacheNotifications();
  renderNotifications();
  showToast(title, message, type);
}

async function markAllAsRead() {
  if (notificationLoadPromise) await notificationLoadPromise;
  const readAt = new Date().toISOString();
  notificationItems = notificationItems.map((notification) => ({ ...notification, read_at: readAt }));
  liveNotifications = liveNotifications.map((notification) => ({ ...notification, read_at: readAt }));
  cacheNotifications();
  renderNotifications();

  const result = await postJSON(`${API}/notifications.php`, { action: 'mark_read' });
  if (!result.success) {
    notificationLoadError = result.message || 'Notifications could not be marked as read.';
    renderNotifications();
    showToast('Notifications not updated', notificationLoadError, 'danger');
    loadStoredNotifications();
  }
}

function formatTimeAgo(isoString) {
  const date = new Date(isoString);
  const seconds = Math.floor((new Date() - date) / 1000);

  if (seconds < 30) return 'Just now';
  let interval = Math.floor(seconds / 31536000);
  if (interval > 1) return `${interval} years ago`;
  if (interval === 1) return '1 year ago';

  interval = Math.floor(seconds / 2592000);
  if (interval > 1) return `${interval} months ago`;
  if (interval === 1) return '1 month ago';

  interval = Math.floor(seconds / 86400);
  if (interval > 1) return `${interval} days ago`;
  if (interval === 1) return '1 day ago';

  interval = Math.floor(seconds / 3600);
  if (interval > 1) return `${interval} hours ago`;
  if (interval === 1) return '1 hour ago';

  interval = Math.floor(seconds / 60);
  if (interval > 1) return `${interval} minutes ago`;
  if (interval === 1) return '1 minute ago';

  return 'Just now';
}

function updateTimeAgoDisplay() {
  const notifList = document.getElementById('notif-list');
  if (!notifList) return;

  notifList.querySelectorAll('.notif-item').forEach(item => {
    const timestamp = item.dataset.timestamp;
    if (timestamp) {
      const timeEl = item.querySelector('.time-ago');
      if (timeEl) {
        timeEl.textContent = formatTimeAgo(timestamp);
      }
    }
  });
}

function updateBadge() {
  const badge = document.getElementById('notif-badge');
  if (!badge) return;

  if (unreadCount > 0) {
    badge.textContent = unreadCount > 99 ? '99+' : unreadCount;
    badge.style.display = 'flex';
  } else {
    badge.style.display = 'none';
  }
}

function updateDeviceLocalTime() {
  const now = new Date();
  const greeting = document.querySelector('[data-local-greeting]');
  const date = document.querySelector('[data-local-date]');
  const time = document.querySelector('[data-local-time]');

  if (greeting) {
    const hour = now.getHours();
    const salutation = hour < 12 ? 'Good morning' : (hour < 17 ? 'Good afternoon' : 'Good evening');
    greeting.textContent = `${salutation}, ${greeting.dataset.firstName || 'there'}! 👋`;
  }
  if (date) {
    date.textContent = now.toLocaleDateString(undefined, {
      weekday: 'long',
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    });
  }
  if (time) {
    time.textContent = now.toLocaleTimeString(undefined, {
      hour: 'numeric',
      minute: '2-digit',
    });
  }
}

function initDeviceLocalTime() {
  updateDeviceLocalTime();
  setInterval(updateDeviceLocalTime, 30000);
  document.addEventListener('retrieva:paint', updateDeviceLocalTime);
}

function getNotifIcon(type) {
  switch (type) {
    case 'success': return '✅';
    case 'warning': return '⚠️';
    case 'danger':  return '🚨';
    default:        return '📦';
  }
}

function showToast(title, message, type = 'info') {
  const container = document.getElementById('toast-container');
  if (!container) return;

  const toast = document.createElement('div');
  toast.className = `toast toast--${type}`;
  toast.innerHTML = `
    <span class="toast__icon">${getNotifIcon(type)}</span>
    <div class="toast__body">
      <strong>${escapeHtml(title)}</strong>
      <span>${escapeHtml(message)}</span>
    </div>
    <button class="toast__close" onclick="this.parentElement.remove()">&times;</button>
  `;

  container.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(-10px)';
    setTimeout(() => toast.remove(), 300);
  }, 5000);
}

/* -------------------------------------------------------------------------
 * REAL-TIME PUSHER WEBSOCKET LISTENER
 * ------------------------------------------------------------------------- */
function initPusherNotifications() {
  if (typeof Pusher === 'undefined') {
    console.error('Pusher SDK is not loaded. Make sure pusher.min.js is included before dashboard.js.');
    return;
  }

  const userId = window.RETRIEVA_USER_ID;
  const role = document.body?.dataset?.role || 'student';
  const isStaff = role === 'admin' || role === 'security';

  const pusher = new Pusher('37ca687c653f5f52a830', {
    cluster: 'eu',
    forceTLS: true,
    authEndpoint: '../database/pusher_auth.php',
  });

  const handleSyncEvent = (eventName) => {
    scheduleLiveSync(eventName);
  };

  if (userId !== null && userId !== undefined && userId !== '') {
    const userChannel = pusher.subscribe(`private-user-${userId}`);
    userChannel.bind('notification', (data) => {
      addNotification(
        data.title || 'Notification',
        data.message || '',
        data.type || 'info',
        data
      );
    });
    userChannel.bind('claim:updated', () => handleSyncEvent('claim:updated'));
    userChannel.bind('item:updated', () => handleSyncEvent('item:updated'));
    userChannel.bind('pickup:verified', () => handleSyncEvent('pickup:verified'));
  }

  const updatesChannel = pusher.subscribe('private-updates');
  updatesChannel.bind('claim:updated', () => handleSyncEvent('claim:updated'));
  updatesChannel.bind('item:updated', () => handleSyncEvent('item:updated'));
  updatesChannel.bind('pickup:verified', () => handleSyncEvent('pickup:verified'));

  if (isStaff) {
    const staffChannel = pusher.subscribe('private-staff');
    staffChannel.bind('claim:updated', () => handleSyncEvent('claim:updated'));
    staffChannel.bind('item:updated', () => handleSyncEvent('item:updated'));
    staffChannel.bind('pickup:verified', () => handleSyncEvent('pickup:verified'));
  }

  pusher.connection.bind('state_change', (states) => {
    const statusEl = document.getElementById('pusher-status');
    if (statusEl) {
      if (states.current === 'connected') {
        statusEl.className = 'status-connected';
        statusEl.innerHTML = '<span class="status-dot"></span> Active';
      } else {
        statusEl.className = 'status-disconnected';
        statusEl.innerHTML = '<span class="status-dot"></span> Reconnecting...';
      }
    }
  });
}

let liveSyncTimer = null;
function scheduleLiveSync() {
  clearTimeout(liveSyncTimer);
  liveSyncTimer = setTimeout(() => {
    const page = document.body?.dataset?.page || '';
    if (page === 'dashboard') {
      refreshDashboardLive();
    } else if (page === 'reports' && typeof window.refreshReportsLive === 'function') {
      window.refreshReportsLive();
    } else if (['claims', 'pending-verifications', 'found-items', 'lost-items', 'my-reports', 'pickup-verification'].includes(page)) {
      refreshPageTablesLive();
    }
  }, 250);
}

async function refreshDashboardLive() {
  try {
    const res = await fetch(`${API}/dashboard_stats.php`, { credentials: 'same-origin' });
    const data = await res.json();
    if (!data.success) return;

    const map = {
      'stat-total-found': data.totalFound,
      'stat-total-lost': data.totalLost,
      'stat-total-claims': data.totalClaims,
      'stat-items-returned': data.itemsReturned,
    };
    Object.entries(map).forEach(([id, val]) => {
      const el = document.getElementById(id);
      if (el) el.textContent = String(val);
    });

    const pendingEl = document.getElementById('pending-claims-count');
    if (pendingEl) {
      pendingEl.textContent = `${data.pendingCount} claim(s) need a decision`;
    }

    const recentBox = document.getElementById('recent-found-list');
    if (recentBox && Array.isArray(data.recentFound)) {
      if (data.recentFound.length === 0) {
        recentBox.innerHTML = '<div style="text-align:center; padding: 24px 0; color:var(--c-text-muted); font-size:13px;"><div style="font-size:24px; margin-bottom:4px;">📥</div>No recently found items recorded.</div>';
      } else {
        recentBox.innerHTML = data.recentFound.map((item) => `
          <div class="found-item-row">
            <div class="found-item-row__thumb">📦</div>
            <div class="found-item-row__meta">
              <strong>${escapeHtml(item.item_name)}</strong>
              <small>${escapeHtml(item.location_found)} · ${escapeHtml(item.date_label)}</small>
            </div>
            <span class="badge ${item.status === 'claimed' ? 'badge--green' : 'badge--amber'}">${escapeHtml(item.status_label)}</span>
          </div>
        `).join('');
      }
    }

    if (window.retrievaLineChart && Array.isArray(data.days)) {
      window.retrievaLineChart.data.labels = data.days;
      window.retrievaLineChart.data.datasets[0].data = data.foundSeries;
      window.retrievaLineChart.data.datasets[1].data = data.lostSeries;
      window.retrievaLineChart.update();
    }

    if (data.categoryData && typeof window.retrievaUpdateCategoryData === 'function') {
      window.retrievaUpdateCategoryData(data.categoryData);
    }
  } catch {
    // Non-blocking live sync
  }
}

async function refreshPageTablesLive() {
  const activeTag = document.activeElement?.tagName;
  if (activeTag === 'INPUT' || activeTag === 'TEXTAREA' || activeTag === 'SELECT') return;
  if (document.querySelector('.modal-overlay.show')) return;

  try {
    const res = await fetch(window.location.href, { credentials: 'same-origin' });
    if (!res.ok) return;
    const html = await res.text();
    const doc = new DOMParser().parseFromString(html, 'text/html');

    const newBodies = doc.querySelectorAll('.data-table tbody');
    const curBodies = document.querySelectorAll('.data-table tbody');
    if (newBodies.length === curBodies.length) {
      curBodies.forEach((tbody, idx) => {
        tbody.innerHTML = newBodies[idx].innerHTML;
      });
    }

    const newStatGrid = doc.querySelector('.stat-grid');
    const curStatGrid = document.querySelector('.stat-grid');
    if (newStatGrid && curStatGrid) {
      curStatGrid.innerHTML = newStatGrid.innerHTML;
    }

    const newBadge = doc.querySelector('.nav-badge');
    const curBadge = document.querySelector('.nav-badge');
    if (newBadge && curBadge) {
      curBadge.textContent = newBadge.textContent;
    }
  } catch {
    // Non-blocking live sync
  }
}

/* -------------------------------------------------------------------------
 * CORE SHELL INITIALIZATION
 * ------------------------------------------------------------------------- */
function initUserMenu() {
  const trigger = document.getElementById('user-menu-trigger');
  const dropdown = document.getElementById('user-menu-dropdown');
  if (!trigger || !dropdown) return;

  trigger.addEventListener('click', (e) => {
    e.stopPropagation();
    dropdown.classList.toggle('show');
    
    const notifDropdown = document.getElementById('notif-dropdown');
    if (notifDropdown) notifDropdown.hidden = true;
  });
  
  document.addEventListener('click', () => dropdown.classList.remove('show'));
  dropdown.addEventListener('click', (e) => e.stopPropagation());
}

function initLogout() {
  document.getElementById('logout-btn')?.addEventListener('click', async () => {
    const r = await postJSON(`${API}/logout.php`);
    clearCachedNotifications();
    window.location.href = r.redirect || '../auth/login.php';
  });
}

function initSidebarToggle() {
  const toggle = document.getElementById('sidebar-toggle');
  const sidebar = document.querySelector('.sidebar');
  if (!toggle || !sidebar) return;
  const closeButton = document.getElementById('sidebar-close');

  const closedIcon = toggle.textContent.trim() || '☰';
  const setOpen = (open, restoreFocus = false) => {
    sidebar.classList.toggle('sidebar--open', open);
    toggle.setAttribute('aria-expanded', String(open));
    toggle.setAttribute('aria-label', open ? 'Close navigation menu' : 'Open navigation menu');
    toggle.textContent = open ? '×' : closedIcon;
    if (restoreFocus) toggle.focus();
  };

  toggle.addEventListener('click', () => {
    setOpen(!sidebar.classList.contains('sidebar--open'));
  });
  closeButton?.addEventListener('click', () => setOpen(false, true));
  sidebar.addEventListener('click', (event) => {
    if (event.target.closest('.nav-item')) setOpen(false);
  });
  document.addEventListener('click', (event) => {
    if (!sidebar.classList.contains('sidebar--open')) return;
    if (sidebar.contains(event.target) || toggle.contains(event.target)) return;
    setOpen(false);
  });
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && sidebar.classList.contains('sidebar--open')) {
      setOpen(false, true);
    }
  });

  setOpen(sidebar.classList.contains('sidebar--open'));
}

function initGlobalSearch() {
  const input = document.getElementById('global-search');
  const results = document.getElementById('global-search-results');
  if (!input || !results) return;
  let timer;
  let controller;

  const close = () => {
    results.hidden = true;
    input.setAttribute('aria-expanded', 'false');
  };

  const render = (items) => {
    results.innerHTML = items.length
      ? items.map((item) => `<a class="search-result" role="option" tabindex="-1" href="${item.url}#${item.type}-${item.id}"><strong>${escapeHtml(item.title)}</strong><small>${escapeHtml(item.type)} · ${escapeHtml(item.context)} · ${escapeHtml(item.status)}</small></a>`).join('')
      : '<span class="search-result search-result--empty">No matching records.</span>';
    results.hidden = false;
    input.setAttribute('aria-expanded', 'true');
  };

  input.addEventListener('input', () => {
    clearTimeout(timer);
    controller?.abort();
    const query = input.value.trim();
    if (query.length < 2) { close(); return; }
    timer = setTimeout(async () => {
      controller = new AbortController();
      results.innerHTML = '<span class="search-result search-result--empty">Searching...</span>';
      results.hidden = false;
      try {
        const response = await fetch(`${API}/search.php?q=${encodeURIComponent(query)}`, { credentials: 'same-origin', signal: controller.signal });
        const data = await response.json();
        if (!data.success) throw new Error(data.message);
        render(data.results || []);
      } catch (error) {
        if (error.name !== 'AbortError') render([]);
      }
    }, 250);
  });

  input.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') { close(); input.value = ''; }
    if (event.key === 'ArrowDown' && !results.hidden) results.querySelector('.search-result')?.focus();
  });

  document.addEventListener('click', (event) => { if (!event.target.closest('.topbar__search')) close(); });
}

function escapeHtml(value) {
  const node = document.createElement('span');
  node.textContent = value ?? '';
  return node.innerHTML;
}

function initStudentIdModal() {
  const form = document.getElementById('student-id-form');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const student_id = document.getElementById('sid-input').value.trim();
    const res = await postJSON(`${API}/save_student_id.php`, { student_id });
    if (res.success) {
      closeModal('student-id-modal-overlay');
      window.location.reload();
    } else {
      alert(res.message || 'Could not save student ID.');
    }
  });
}

function initPasswordSetupModal() {
  const form = document.getElementById('password-setup-form');
  if (!form) return;

  document.getElementById('password-modal-later')?.addEventListener('click', () => {
    closeModal('password-modal-overlay');
  });

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const password = document.getElementById('ps-password').value;
    const confirm_password = document.getElementById('ps-confirm').value;
    const skip_next_time = document.getElementById('ps-skip-next-time').checked;

    if (password.length < 8) { alert('Password must be at least 8 characters.'); return; }
    if (password !== confirm_password) { alert('Passwords do not match.'); return; }

    const res = await postJSON(`${API}/save_password.php`, { password, confirm_password, skip_next_time });
    if (res.success) {
      closeModal('password-modal-overlay');
    } else {
      alert(res.message || 'Could not save password.');
    }
  });
}

function initConfirmModal() {
  const modal = document.getElementById('confirm-action-modal');
  const titleEl = document.getElementById('confirm-action-title');
  const msgEl = document.getElementById('confirm-action-message');
  const cancelBtn = document.getElementById('confirm-action-cancel');
  const submitBtn = document.getElementById('confirm-action-submit');
  if (!modal || !submitBtn) {
    document.addEventListener('submit', (event) => {
      const form = event.target.closest('form[data-confirm]');
      if (!form || form.dataset.confirmed === '1') return;
      if (!window.confirm(form.dataset.confirm || 'Are you sure you want to continue?')) {
        event.preventDefault();
        return;
      }
      form.dataset.confirmed = '1';
    });
    return;
  }

  let pendingForm = null;

  const close = () => {
    modal.classList.remove('show');
    pendingForm = null;
  };

  document.addEventListener('submit', (event) => {
    const form = event.target.closest('form[data-confirm]');
    if (!form || form.dataset.confirmed === '1') return;
    event.preventDefault();
    pendingForm = form;
    if (titleEl) titleEl.textContent = form.dataset.confirmTitle || 'Confirm Action';
    if (msgEl) msgEl.textContent = form.dataset.confirm || 'Are you sure you want to continue?';
    submitBtn.textContent = form.dataset.confirmBtn || 'Confirm';
    modal.classList.add('show');
    cancelBtn?.focus();
  });

  cancelBtn?.addEventListener('click', close);
  modal.addEventListener('click', (event) => {
    if (event.target === modal) close();
  });
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && modal.classList.contains('show')) close();
  });

  submitBtn.addEventListener('click', () => {
    if (!pendingForm) return;
    const formToSubmit = pendingForm;
    formToSubmit.dataset.confirmed = '1';
    close();
    formToSubmit.submit();
  });
}

/* -------------------------------------------------------------------------
 * GLOBAL SCOPE EXPORTS & INITIALIZATION
 * ------------------------------------------------------------------------- */
window.addNotification = addNotification;
window.showToast = showToast;

document.addEventListener('DOMContentLoaded', () => {
  initDeviceLocalTime();
  initUserMenu();
  initLogout();
  initSidebarToggle();
  initGlobalSearch();
  initStudentIdModal();
  initPasswordSetupModal();
  initConfirmModal();
  initNotifications();
  initPusherNotifications();
});