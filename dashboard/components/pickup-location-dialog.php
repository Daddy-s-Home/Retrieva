<dialog class="pickup-location-dialog" id="pickup-location-dialog" aria-labelledby="pickup-location-title" aria-describedby="pickup-location-instructions">
  <form method="post" id="pickup-location-form" action="" data-close-on-success="true">
    <?= csrf_field() ?>
    <input type="hidden" name="action" id="pickup-location-action">
    <input type="hidden" name="claim_id" id="pickup-location-claim-id">
    <input type="hidden" name="redirect" id="pickup-location-redirect">
    <header class="pickup-location-dialog__header">
      <h2 id="pickup-location-title">Confirm claim approval</h2>
      <p id="pickup-location-instructions">Enter where the item is currently being kept for pickup. Include the building, floor, and room if applicable, or a staffed Security post or recognizable campus landmark.</p>
    </header>
    <label class="pickup-location-dialog__label" for="pickup-location-input">Current pickup location <span>Required</span></label>
    <input id="pickup-location-input" class="pickup-location-dialog__input" type="text" name="pickup_location" maxlength="255" required autocomplete="off" aria-describedby="pickup-location-instructions">
    <div class="pickup-location-dialog__actions">
      <button class="btn btn-ghost" type="button" data-close-pickup-location>Cancel</button>
      <button class="btn btn-primary" type="submit">Approve claim</button>
    </div>
  </form>
</dialog>
