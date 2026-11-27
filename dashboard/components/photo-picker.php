<?php
declare(strict_types=1);

function dashboard_photo_picker(array $photos): string {
    $html = '<fieldset class="photo-picker" data-photo-picker>'
        . '<legend>Item photos</legend>'
        . '<p class="photo-picker__help">Add 1 to 5 JPEG, PNG, or WebP images. Each image must be 2 MB or smaller.</p>';
    if ($photos !== []) {
        $html .= '<div class="photo-picker__current">';
        foreach ($photos as $index => $photo) {
            $photoIndex = (int) ($photo['id'] ?? $index);
            $html .= '<label class="photo-thumb"><img src="' . h((string) ($photo['src'] ?? '')) . '" alt="">'
                . '<span>Remove</span><input type="checkbox" name="remove_photos[]" value="' . $photoIndex . '" data-existing-photo aria-label="Remove photo"></label>';
        }
        $html .= '</div>';
    }
    $html .= '<div class="photo-picker__preview" data-photo-preview></div>'
        . '<label class="photo-picker__file-label">Choose image files'
        . '<input type="file" name="photos[]" accept="image/jpeg,image/png,image/webp" multiple data-photo-files></label>'
        . '<button type="button" class="btn btn-ghost" data-photo-camera>Use camera</button>'
        . '<p class="photo-picker__message" data-photo-message role="status" aria-live="polite"></p>'
        . '<div class="photo-picker__camera" data-photo-stage hidden><video data-photo-video playsinline autoplay muted></video>'
        . '<button type="button" class="btn btn-primary" data-photo-snap>Capture photo</button>'
        . '<button type="button" class="btn btn-ghost" data-photo-stop>Close camera</button></div></fieldset>';

    return $html;
}
