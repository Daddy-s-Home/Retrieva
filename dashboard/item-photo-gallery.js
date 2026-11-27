(function () {
  const dialog = document.getElementById('item-photo-gallery');
  const title = document.getElementById('item-photo-gallery-title');
  const image = document.getElementById('item-photo-gallery-image');
  const fallback = document.getElementById('item-photo-gallery-fallback');
  const counter = document.getElementById('item-photo-gallery-count');
  const stage = document.getElementById('item-photo-gallery-stage');
  if (!dialog || !title || !image || !fallback || !counter || !stage) return;

  const previous = dialog.querySelector('[data-gallery-previous]');
  const next = dialog.querySelector('[data-gallery-next]');
  let photos = [];
  let index = 0;
  let touchStartX = null;

  function showPhoto() {
    image.hidden = false;
    fallback.hidden = true;
    image.alt = title.textContent + ' photo ' + (index + 1);
    image.onerror = function () {
      image.hidden = true;
      fallback.hidden = false;
    };
    image.src = photos[index];
    counter.textContent = 'Photo ' + (index + 1) + ' of ' + photos.length;
    previous.disabled = photos.length < 2;
    next.disabled = photos.length < 2;
  }

  function openGallery(trigger) {
    let listedPhotos;
    try {
      listedPhotos = JSON.parse(trigger.dataset.galleryPhotos || '[]');
    } catch (error) {
      console.error('The item photo list could not be read.', error);
      return;
    }
    photos = Array.isArray(listedPhotos)
      ? listedPhotos.filter((src) => typeof src === 'string' && src !== '').slice(0, 5)
      : [];
    if (photos.length === 0) return;
    index = 0;
    title.textContent = trigger.dataset.galleryTitle || 'Item photos';
    showPhoto();
    if (!dialog.open) dialog.showModal();
  }

  function movePhoto(direction) {
    if (photos.length < 2) return;
    index = (index + direction + photos.length) % photos.length;
    showPhoto();
  }

  document.addEventListener('click', (event) => {
    const trigger = event.target.closest('[data-item-gallery]');
    if (trigger) {
      openGallery(trigger);
      return;
    }
    if (event.target.closest('[data-close-item-gallery]') && dialog.open) {
      dialog.close();
      return;
    }
    if (event.target === dialog && dialog.open) dialog.close();
    if (event.target.closest('[data-gallery-previous]')) movePhoto(-1);
    if (event.target.closest('[data-gallery-next]')) movePhoto(1);
  });

  document.addEventListener('error', (event) => {
    if (event.target.matches('.item-photo-preview__image')) {
      const preview = event.target.closest('.item-photo-preview');
      event.target.hidden = true;
      preview?.querySelector('.item-photo-preview__fallback')?.removeAttribute('hidden');
    }
  }, true);

  dialog.addEventListener('keydown', (event) => {
    if (event.key === 'ArrowLeft') {
      event.preventDefault();
      movePhoto(-1);
    } else if (event.key === 'ArrowRight') {
      event.preventDefault();
      movePhoto(1);
    }
  });

  stage.addEventListener('touchstart', (event) => {
    touchStartX = event.changedTouches[0]?.clientX ?? null;
  }, { passive: true });

  stage.addEventListener('touchend', (event) => {
    const touchEndX = event.changedTouches[0]?.clientX;
    if (touchStartX === null || typeof touchEndX !== 'number') return;
    const distance = touchEndX - touchStartX;
    if (Math.abs(distance) >= 48) movePhoto(distance < 0 ? 1 : -1);
    touchStartX = null;
  }, { passive: true });
})();
