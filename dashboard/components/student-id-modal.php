<div class="modal-overlay show" id="student-id-modal-overlay" role="dialog" aria-modal="true" aria-labelledby="student-id-modal-title">
  <div class="modal-card">
    <div class="modal-card__badge" aria-hidden="true">🎓</div>
    <h2 id="student-id-modal-title">Confirm your Student ID</h2>
    <p class="modal-subtitle">
      We need your student ID on file so claims and pickups can be matched to you.
    </p>

    <form id="student-id-form" novalidate>
      <div class="field">
        <label for="sid-input">Student ID</label>
        <input type="text" id="sid-input" name="student_id" placeholder="e.g. 21-00123" required>
      </div>

      <div class="modal-actions modal-actions--end">
        <button type="submit" class="btn btn-primary">Save Student ID</button>
      </div>
    </form>
  </div>
</div>
