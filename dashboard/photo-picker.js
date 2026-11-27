(function () {
  const allowedTypes = new Set(['image/jpeg', 'image/png', 'image/webp']);

  function photoFiles(picker) {
    if (!picker._photoFiles) picker._photoFiles = [];
    return picker._photoFiles;
  }

  function keptPhotoCount(picker) {
    return Array.from(picker.querySelectorAll('[data-existing-photo]')).filter((input) => !input.checked).length;
  }

  function setMessage(picker, message) {
    const status = picker.querySelector('[data-photo-message]');
    if (status) status.textContent = message;
  }

  function releasePreviewUrls(picker) {
    (picker._photoPreviewUrls || []).forEach((url) => URL.revokeObjectURL(url));
    picker._photoPreviewUrls = [];
  }

  function renderPreview(picker) {
    const preview = picker.querySelector('[data-photo-preview]');
    if (!preview) return;
    releasePreviewUrls(picker);
    preview.replaceChildren();
    photoFiles(picker).forEach((file, index) => {
      const figure = document.createElement('figure');
      const image = document.createElement('img');
      const button = document.createElement('button');
      const url = URL.createObjectURL(file);
      picker._photoPreviewUrls.push(url);
      image.src = url;
      image.alt = 'Selected photo preview';
      button.type = 'button';
      button.className = 'btn btn-ghost';
      button.textContent = 'Remove';
      button.dataset.photoRemove = String(index);
      figure.append(image, button);
      preview.append(figure);
    });
  }

  function syncInput(picker) {
    const input = picker.querySelector('[data-photo-files]');
    if (!input) return false;
    if (typeof DataTransfer === 'undefined') {
      return input.files.length === photoFiles(picker).length;
    }
    try {
      const transfer = new DataTransfer();
      photoFiles(picker).forEach((file) => transfer.items.add(file));
      input.files = transfer.files;
      return true;
    } catch (error) {
      setMessage(picker, 'Your browser cannot attach camera photos. Choose image files instead.');
      return false;
    }
  }

  function addPhotoFiles(picker, incoming) {
    const files = Array.from(incoming);
    const room = 5 - keptPhotoCount(picker) - photoFiles(picker).length;
    if (room <= 0) {
      setMessage(picker, 'You can add up to 5 photos.');
      return;
    }
    const accepted = [];
    files.forEach((file) => {
      if (file.type && !allowedTypes.has(file.type)) {
        setMessage(picker, 'Use a JPEG, PNG, or WebP image.');
      } else if (file.size > 2000000) {
        setMessage(picker, 'Each photo must be 2 MB or smaller.');
      } else if (accepted.length >= room) {
        setMessage(picker, 'You can add up to 5 photos.');
      } else {
        accepted.push(file);
      }
    });
    photoFiles(picker).push(...accepted);
    renderPreview(picker);
    syncInput(picker);
  }

  function stopCamera(picker) {
    const video = picker.querySelector('[data-photo-video]');
    const stream = video && video.srcObject;
    if (stream && stream.getTracks) stream.getTracks().forEach((track) => track.stop());
    if (video) video.srcObject = null;
    const stage = picker.querySelector('[data-photo-stage]');
    if (stage) stage.hidden = true;
  }

  function stopAllCameras() {
    document.querySelectorAll('[data-photo-picker]').forEach((picker) => stopCamera(picker));
  }

  document.addEventListener('change', (event) => {
    if (!(event.target instanceof Element)) return;
    const input = event.target.closest('[data-photo-files]');
    if (!input) return;
    const picker = input.closest('[data-photo-picker]');
    if (!picker) return;
    const selected = Array.from(input.files || []);
    if (typeof DataTransfer === 'undefined') {
      picker._photoFiles = selected;
      renderPreview(picker);
      if (selected.length + keptPhotoCount(picker) > 5) {
        setMessage(picker, 'You can add up to 5 photos.');
      }
      return;
    }
    input.value = '';
    addPhotoFiles(picker, selected);
  });

  document.addEventListener('click', async (event) => {
    if (!(event.target instanceof Element)) return;
    const cameraButton = event.target.closest('[data-photo-camera]');
    if (cameraButton) {
      const picker = cameraButton.closest('[data-photo-picker]');
      if (!picker) return;
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        setMessage(picker, 'Camera access is unavailable. Choose image files instead.');
        return;
      }
      stopAllCameras();
      try {
        const stream = await navigator.mediaDevices.getUserMedia({
          audio: false,
          video: { facingMode: { ideal: 'environment' } },
        });
        const video = picker.querySelector('[data-photo-video]');
        video.srcObject = stream;
        await video.play();
        picker.querySelector('[data-photo-stage]').hidden = false;
        setMessage(picker, '');
      } catch (error) {
        stopCamera(picker);
        setMessage(picker, 'Camera access was denied or unavailable. Choose image files instead.');
      }
      return;
    }

    const captureButton = event.target.closest('[data-photo-snap]');
    if (captureButton) {
      const picker = captureButton.closest('[data-photo-picker]');
      const video = picker && picker.querySelector('[data-photo-video]');
      if (!picker || !video) return;
      if (typeof DataTransfer === 'undefined' || typeof File === 'undefined') {
        stopCamera(picker);
        setMessage(picker, 'Camera capture is not supported in this browser. Choose image files instead.');
        return;
      }
      if (!video.videoWidth || !video.videoHeight) {
        setMessage(picker, 'Wait for the camera preview before capturing a photo.');
        return;
      }
      const canvas = document.createElement('canvas');
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      const context = canvas.getContext('2d');
      if (!context) {
        stopCamera(picker);
        setMessage(picker, 'The photo could not be captured. Choose image files instead.');
        return;
      }
      context.drawImage(video, 0, 0, canvas.width, canvas.height);
      canvas.toBlob((blob) => {
        stopCamera(picker);
        if (!blob) {
          setMessage(picker, 'The photo could not be captured. Please try again.');
          return;
        }
        addPhotoFiles(picker, [new File([blob], 'camera-' + Date.now() + '.jpg', { type: 'image/jpeg' })]);
      }, 'image/jpeg', 0.85);
      return;
    }

    const stopButton = event.target.closest('[data-photo-stop]');
    if (stopButton) {
      const picker = stopButton.closest('[data-photo-picker]');
      if (picker) stopCamera(picker);
      return;
    }

    const removeButton = event.target.closest('[data-photo-remove]');
    if (removeButton) {
      const picker = removeButton.closest('[data-photo-picker]');
      if (!picker) return;
      photoFiles(picker).splice(Number(removeButton.dataset.photoRemove), 1);
      renderPreview(picker);
      syncInput(picker);
      setMessage(picker, '');
    }
  });

  document.addEventListener('submit', (event) => {
    const form = event.target;
    if (!(form instanceof HTMLFormElement)) return;
    const pickers = Array.from(form.querySelectorAll('[data-photo-picker]'));
    for (const picker of pickers) {
      const synced = syncInput(picker);
      const total = keptPhotoCount(picker) + photoFiles(picker).length;
      if (!synced || total < 1 || total > 5) {
        event.preventDefault();
        event.stopImmediatePropagation();
        setMessage(picker, !synced
          ? 'Your browser could not attach the selected images. Choose image files again.'
          : total < 1
            ? 'Add at least one photo.'
            : 'You can add up to 5 photos.');
        picker.querySelector('[data-photo-files]')?.focus();
        return;
      }
      setMessage(picker, '');
    }
  }, true);

  document.addEventListener('visibilitychange', () => {
    if (document.hidden) stopAllCameras();
  });
  window.addEventListener('pagehide', stopAllCameras);
  window.RetrievaPhotoPicker = { stopAllCameras };
})();
