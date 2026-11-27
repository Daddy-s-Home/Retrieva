(function () {
  const dialog = document.getElementById('pickup-location-dialog');
  const form = document.getElementById('pickup-location-form');
  const locationInput = document.getElementById('pickup-location-input');
  if (!dialog || !form || !locationInput) return;

  const actionInput = document.getElementById('pickup-location-action');
  const claimIdInput = document.getElementById('pickup-location-claim-id');
  const redirectInput = document.getElementById('pickup-location-redirect');

  document.addEventListener('click', (event) => {
    const trigger = event.target.closest('[data-open-pickup-location]');
    if (trigger) {
      form.reset();
      form.action = trigger.dataset.approvalEndpoint || location.pathname;
      actionInput.value = trigger.dataset.approvalAction || '';
      claimIdInput.value = trigger.dataset.claimId || '';
      redirectInput.value = trigger.dataset.approvalRedirect || '';
      if (trigger.dataset.approvalAjax === 'true') {
        form.setAttribute('data-client-ajax', '');
      } else {
        form.removeAttribute('data-client-ajax');
      }
      if (!dialog.open) dialog.showModal();
      locationInput.focus();
      return;
    }

    if (event.target.closest('[data-close-pickup-location]') && dialog.open) {
      dialog.close();
      return;
    }

    if (event.target === dialog && dialog.open) dialog.close();
  });
})();
