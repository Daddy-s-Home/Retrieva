(function () {
  const warm = window.RetrievaWarm || { current: '', modules: {} };
  const cache = {};
  const moduleRoot = document.getElementById('client-module');
  const drawer = document.getElementById('client-drawer');
  const drawerBody = document.getElementById('client-drawer-body');

  function showToast(message, type) {
    if (!message) return;
    let toast = document.querySelector('.toast');
    if (!toast) {
      toast = document.createElement('div');
      toast.className = 'toast';
      document.body.appendChild(toast);
    }
    toast.textContent = message;
    toast.className = 'toast show' + (type ? ' toast-' + type : '');
    clearTimeout(toast._timer);
    toast._timer = setTimeout(() => toast.classList.remove('show'), 3200);
  }
  window.showToast = showToast;

  function rememberToast(message, type) {
    try {
      sessionStorage.setItem('retrieva_toast', JSON.stringify({ message: message, type: type || 'success' }));
    } catch (error) {
      showToast(message, type);
    }
  }

  function showStoredToast() {
    try {
      const raw = sessionStorage.getItem('retrieva_toast');
      if (!raw) return;
      sessionStorage.removeItem('retrieva_toast');
      const toast = JSON.parse(raw);
      showToast(toast.message, toast.type || 'success');
    } catch (error) {
      /* a stored toast is optional */
    }
  }

  function showSearchToast() {
    const empty = document.getElementById('client-search-empty');
    if (empty && empty.dataset.toast) showToast(empty.dataset.toast, 'error');
  }

  async function readJson(response) {
    const text = await response.text();
    if (!text) return { success: false, message: 'The server returned an empty response.' };
    try {
      return JSON.parse(text);
    } catch (error) {
      return { success: false, message: 'The server could not complete that action.' };
    }
  }

  function cacheKey(name, search) {
    return name + (search || '');
  }

  function remember(name, search, payload) {
    if (payload && payload.success) cache[cacheKey(name, search)] = payload;
  }

  if (moduleRoot && warm.current) {
    remember(warm.current, location.search, { success: true, module: warm.current, html: moduleRoot.innerHTML });
  }

  function ensureStyle(href) {
    const existing = document.querySelector('link[data-module-style="' + href + '"]');
    if (existing) return;
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = href;
    link.dataset.moduleStyle = href;
    document.head.appendChild(link);
  }

  function ensureScript(src) {
    if (document.querySelector('script[data-module-script="' + src + '"]')) return Promise.resolve();
    return new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = src;
      script.dataset.moduleScript = src;
      script.onload = () => resolve();
      script.onerror = () => reject(new Error('Script failed'));
      document.body.appendChild(script);
    });
  }

  function moduleFromUrl(urlValue) {
    const url = new URL(urlValue, location.href);
    const file = url.pathname.split('/').pop();
    const found = Object.entries(warm.modules).find(([, meta]) => meta.page === file);
    return found ? { name: found[0], search: url.search } : null;
  }

  async function loadPayload(name, search) {
    const key = cacheKey(name, search);
    if (cache[key]) return cache[key];
    if (!search && window.RetrievaPrefetch && window.RetrievaPrefetch[name]) {
      const payload = await window.RetrievaPrefetch[name];
      remember(name, '', payload);
      if (cache[key]) return cache[key];
    }
    const response = await fetch(warm.modules[name].api + (search || ''), {
      credentials: 'same-origin',
      headers: { Accept: 'application/json' },
    });
    const payload = await readJson(response);
    remember(name, search, payload);
    return payload;
  }

  function stopCameras() {
    document.querySelectorAll('[data-photo-video]').forEach((video) => {
      const stream = video.srcObject;
      if (stream && stream.getTracks) stream.getTracks().forEach((track) => track.stop());
      video.srcObject = null;
    });
  }

  function photoFiles(picker) {
    if (!picker._files) picker._files = [];
    return picker._files;
  }

  function keptPhotos(picker) {
    return Array.from(picker.querySelectorAll('[data-existing-photo]')).filter((box) => !box.checked).length;
  }

  function renderPhotoPreview(picker) {
    const preview = picker.querySelector('[data-photo-preview]');
    if (!preview) return;
    preview.innerHTML = '';
    photoFiles(picker).forEach((file, index) => {
      const figure = document.createElement('figure');
      const img = document.createElement('img');
      img.src = URL.createObjectURL(file);
      img.alt = 'New photo';
      const button = document.createElement('button');
      button.type = 'button';
      button.className = 'btn btn-ghost';
      button.textContent = 'Remove';
      button.dataset.photoRemove = String(index);
      figure.append(img, button);
      preview.append(figure);
    });
  }

  function syncPhotoInput(picker) {
    const input = picker.querySelector('[data-photo-files]');
    if (!input || typeof DataTransfer === 'undefined') return;
    const transfer = new DataTransfer();
    photoFiles(picker).forEach((file) => transfer.items.add(file));
    input.files = transfer.files;
  }

  function addPhotoFiles(picker, files) {
    const room = 5 - keptPhotos(picker) - photoFiles(picker).length;
    if (room <= 0) {
      showToast('You can add up to 5 photos.', 'error');
      return;
    }
    const accepted = Array.from(files).slice(0, room);
    if (accepted.length < files.length) showToast('You can add up to 5 photos.', 'error');
    accepted.forEach((file) => photoFiles(picker).push(file));
    renderPhotoPreview(picker);
    syncPhotoInput(picker);
  }

  function dropModuleCache(name) {
    Object.keys(cache).forEach((key) => {
      if (key === name || key.startsWith(name + '?')) delete cache[key];
    });
    if (window.RetrievaPrefetch) delete window.RetrievaPrefetch[name];
  }

  async function paint(name, search, push) {
    stopCameras();
    const meta = warm.modules[name];
    if (!meta || !moduleRoot) return;
    ensureStyle(meta.css);
    let payload;
    try {
      payload = await loadPayload(name, search);
    } catch (error) {
      showToast('This page could not be loaded.', 'error');
      return;
    }
    if (!payload || !payload.success) {
      moduleRoot.innerHTML = '<p class="empty">This page could not be loaded.</p>';
      showToast((payload && payload.message) || 'This page could not be loaded.', 'error');
      return;
    }
    moduleRoot.innerHTML = payload.html || '';
    moduleRoot.className = 'client-module module-' + name;
    document.querySelectorAll('.client-nav').forEach((link) => {
      link.classList.toggle('active', link.dataset.module === name);
    });
    const searchForm = document.getElementById('client-search-form');
    if (searchForm) {
      const target = name === 'dashboard' ? 'found-items' : name;
      searchForm.action = warm.modules[target].page;
      searchForm.dataset.searchModule = target;
      const input = document.getElementById('client-search');
      if (input) input.placeholder = warm.modules[target === name || name !== 'dashboard' ? name : target].search;
    }
    try { await ensureScript(meta.js); } catch (error) { /* the server-rendered controls still work */ }
    document.dispatchEvent(new CustomEvent('retrieva:paint', { detail: { module: name } }));
    showSearchToast();
    if (push) history.pushState({ module: name }, '', meta.page + (search || ''));
    moduleRoot.focus({ preventScroll: true });
  }

  document.addEventListener('click', async (event) => {
    const cameraButton = event.target.closest('[data-photo-camera]');
    if (cameraButton) {
      const picker = cameraButton.closest('[data-photo-picker]');
      const stage = picker.querySelector('[data-photo-stage]');
      const video = picker.querySelector('[data-photo-video]');
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        showToast('The camera is not available. Choose a photo file instead.', 'error');
        return;
      }
      try {
        const stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } });
        video.srcObject = stream;
        stage.hidden = false;
      } catch (error) {
        showToast('The camera is blocked. Choose a photo file instead.', 'error');
      }
      return;
    }
    const snapButton = event.target.closest('[data-photo-snap]');
    if (snapButton) {
      const picker = snapButton.closest('[data-photo-picker]');
      const video = picker.querySelector('[data-photo-video]');
      const canvas = document.createElement('canvas');
      canvas.width = video.videoWidth || 640;
      canvas.height = video.videoHeight || 480;
      canvas.getContext('2d').drawImage(video, 0, 0, canvas.width, canvas.height);
      canvas.toBlob((blob) => {
        if (!blob) return;
        addPhotoFiles(picker, [new File([blob], 'camera-' + Date.now() + '.jpg', { type: 'image/jpeg' })]);
      }, 'image/jpeg', 0.85);
      return;
    }
    const stopButton = event.target.closest('[data-photo-stop]');
    if (stopButton) {
      const picker = stopButton.closest('[data-photo-picker]');
      const video = picker.querySelector('[data-photo-video]');
      const stream = video.srcObject;
      if (stream && stream.getTracks) stream.getTracks().forEach((track) => track.stop());
      video.srcObject = null;
      picker.querySelector('[data-photo-stage]').hidden = true;
      return;
    }
    const removeButton = event.target.closest('[data-photo-remove]');
    if (removeButton) {
      const picker = removeButton.closest('[data-photo-picker]');
      photoFiles(picker).splice(Number(removeButton.dataset.photoRemove), 1);
      renderPhotoPreview(picker);
      syncPhotoInput(picker);
      return;
    }
    const closer = event.target.closest('[data-close-drawer]');
    if (closer && drawer) {
      drawer.hidden = true;
      if (drawerBody) drawerBody.innerHTML = '';
      return;
    }
    const detailButton = event.target.closest('[data-open-detail]');
    if (detailButton && drawer && drawerBody) {
      const template = document.getElementById('detail-' + detailButton.dataset.openDetail);
      if (!template) return;
      drawerBody.innerHTML = template.innerHTML;
      drawer.hidden = false;
      const qr = drawerBody.querySelector('[data-qr-token]');
      if (qr && window.QRCode) {
        try {
          new window.QRCode(qr, { text: qr.dataset.qrToken, width: 180, height: 180 });
        } catch (error) {
          qr.textContent = 'The pickup code could not be drawn.';
        }
      }
      drawerBody.querySelector('button, [href], input, textarea')?.focus();
      return;
    }
    const link = event.target.closest('a[href]');
    if (!link || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey || link.target) return;
    if (link.getAttribute('href').startsWith('#')) return;
    const info = moduleFromUrl(link.href);
    if (!info) return;
    event.preventDefault();
    paint(info.name, info.search, true);
  });

  document.addEventListener('change', (event) => {
    const input = event.target.closest('[data-photo-files]');
    if (!input) return;
    const picker = input.closest('[data-photo-picker]');
    const chosen = Array.from(input.files || []);
    input.value = '';
    addPhotoFiles(picker, chosen);
  });

  document.addEventListener('submit', (event) => {
    const form = event.target;
    if (!(form instanceof HTMLFormElement)) return;
    const picker = form.querySelector('[data-photo-picker]');
    if (!picker) return;
    syncPhotoInput(picker);
    const total = keptPhotos(picker) + photoFiles(picker).length;
    if (total < 1 || total > 5) {
      event.preventDefault();
      event.stopImmediatePropagation();
      showToast(total < 1 ? 'Add at least one photo.' : 'You can add up to 5 photos.', 'error');
    }
  }, true);

  document.addEventListener('submit', async (event) => {
    const filterForm = event.target.closest('form[data-client-filter]');
    if (filterForm) {
      event.preventDefault();
      const info = moduleFromUrl(filterForm.action);
      if (!info) return;
      const params = new URLSearchParams(new FormData(filterForm));
      const search = params.toString() ? '?' + params.toString() : '';
      paint(info.name, search, true);
      return;
    }
    const form = event.target.closest('form[data-client-ajax]');
    if (!form) return;
    event.preventDefault();
    const button = form.querySelector('[type="submit"]');
    if (button) button.disabled = true;
    try {
      const actionUrl = form.getAttribute('action') || '';
      const response = await fetch(actionUrl, {
        method: 'POST',
        body: new FormData(form),
        credentials: 'same-origin',
        headers: { Accept: 'application/json', 'X-Requested-With': 'fetch' },
      });
      const payload = await readJson(response);
      if (payload.success && payload.redirect) {
        const info = moduleFromUrl(payload.redirect);
        if (info && warm.modules[info.name]) {
          dropModuleCache(info.name);
          stopCameras();
          if (drawer) {
            drawer.hidden = true;
            if (drawerBody) drawerBody.innerHTML = '';
          }
          showToast(payload.message || 'Saved.', 'success');
          await paint(info.name, info.search, true);
          const next = new URL(payload.redirect, location.href);
          if (next.hash) location.hash = next.hash;
          return;
        }
        rememberToast(payload.message || 'Saved.', 'success');
        window.location.href = payload.redirect;
        return;
      }
      showToast(payload.message || (payload.success ? 'Saved.' : 'That action could not be completed.'), payload.success ? 'success' : 'error');
      if (button) button.disabled = false;
    } catch (error) {
      showToast('That action could not be completed.', 'error');
      if (button) button.disabled = false;
    }
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && drawer && !drawer.hidden) {
      drawer.hidden = true;
      if (drawerBody) drawerBody.innerHTML = '';
    }
  });

  window.addEventListener('popstate', () => {
    const info = moduleFromUrl(location.href);
    if (info) paint(info.name, info.search, false);
  });

  const searchForm = document.getElementById('client-search-form');
  searchForm?.addEventListener('submit', (event) => {
    event.preventDefault();
    const moduleName = searchForm.dataset.searchModule;
    const params = new URLSearchParams(new FormData(searchForm));
    const search = params.toString() ? '?' + params.toString() : '';
    paint(moduleName, search, true);
  });

  window.addEventListener('DOMContentLoaded', () => {
    showStoredToast();
    showSearchToast();
    document.dispatchEvent(new CustomEvent('retrieva:paint', { detail: { module: warm.current } }));
  });
})();
