/**
 * dashboard.js — shell interactivity only.
 * Header, sidebar, and the first-login modals are rendered server-side
 * (PHP includes reading the session directly) — this file just wires
 * up the dropdown, mobile sidebar toggle, logout, and modal forms that
 * are already present in the DOM when the page loads.
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

function initUserMenu() {
  const trigger = document.getElementById('user-menu-trigger');
  const dropdown = document.getElementById('user-menu-dropdown');
  if (!trigger || !dropdown) return;

  trigger.addEventListener('click', (e) => {
    e.stopPropagation();
    dropdown.classList.toggle('show');
  });
  document.addEventListener('click', () => dropdown.classList.remove('show'));
  dropdown.addEventListener('click', (e) => e.stopPropagation());
}

function initLogout() {
  document.getElementById('logout-btn')?.addEventListener('click', async () => {
    const r = await postJSON(`${API}/logout.php`);
    window.location.href = r.redirect || '../auth/login.php';
  });
}

function initSidebarToggle() {
  document.getElementById('sidebar-toggle')?.addEventListener('click', () => {
    document.querySelector('.sidebar')?.classList.toggle('sidebar--open');
  });
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
      ? items.map((item, index) => `<a class="search-result" role="option" tabindex="-1" href="${item.url}#${item.type}-${item.id}"><strong>${escapeHtml(item.title)}</strong><small>${escapeHtml(item.type)} · ${escapeHtml(item.context)} · ${escapeHtml(item.status)}</small></a>`).join('')
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

/** Only present in the DOM at all if _bootstrap.php decided the student needs it. */
function initStudentIdModal() {
  const form = document.getElementById('student-id-form');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const student_id = document.getElementById('sid-input').value.trim();
    const res = await postJSON(`${API}/save_student_id.php`, { student_id });
    if (res.success) {
      closeModal('student-id-modal-overlay');
      window.location.reload(); // re-render the shell now that the field is set
    } else {
      alert(res.message || 'Could not save student ID.');
    }
  });
}

/** Only present in the DOM at all if _bootstrap.php decided this Google user needs it. */
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

document.addEventListener('DOMContentLoaded', () => {
  initUserMenu();
  initLogout();
  initSidebarToggle();
  initGlobalSearch();
  initStudentIdModal();
  initPasswordSetupModal();
});
