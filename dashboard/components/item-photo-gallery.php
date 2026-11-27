<?php
declare(strict_types=1);

function dashboard_photo_preview(array $photos, string $itemName, string $variant = 'table'): string {
    $sources = [];
    foreach ($photos as $photo) {
        $src = (string) ($photo['src'] ?? '');
        if ($src !== '' && !in_array($src, $sources, true)) {
            $sources[] = $src;
            if (count($sources) === 5) {
                break;
            }
        }
    }
    $variant = in_array($variant, ['table', 'card', 'row'], true) ? $variant : 'table';
    if ($sources === []) {
        return '<div class="item-photo-preview item-photo-preview--' . $variant . ' item-photo-preview--empty" role="img" aria-label="No photo available for ' . h($itemName) . '"><span>N/A</span></div>';
    }

    $photoData = json_encode($sources, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_AMP | JSON_HEX_QUOT | JSON_INVALID_UTF8_SUBSTITUTE);
    if (!is_string($photoData)) {
        throw new RuntimeException('The item photo gallery could not be prepared.');
    }

    return '<button class="item-photo-preview item-photo-preview--' . $variant . '" type="button" data-item-gallery data-gallery-photos="' . h($photoData) . '" data-gallery-title="' . h($itemName) . '" aria-label="View photos of ' . h($itemName) . '">'
        . '<img class="item-photo-preview__image" src="' . h($sources[0]) . '" alt="" loading="lazy">'
        . '<span class="item-photo-preview__overlay" aria-hidden="true">View Item</span>'
        . '<span class="item-photo-preview__fallback" role="img" aria-label="Photo unavailable" hidden>N/A</span>'
        . '</button>';
}

function dashboard_photo_gallery_dialog(): string {
    return '<dialog class="item-photo-gallery" id="item-photo-gallery" aria-labelledby="item-photo-gallery-title">'
        . '<div class="item-photo-gallery__panel">'
        . '<header class="item-photo-gallery__header"><h2 id="item-photo-gallery-title"></h2><button class="item-photo-gallery__close" type="button" data-close-item-gallery aria-label="Close photo gallery">×</button></header>'
        . '<div class="item-photo-gallery__stage" id="item-photo-gallery-stage">'
        . '<button class="item-photo-gallery__arrow" type="button" data-gallery-previous aria-label="Previous photo">‹</button>'
        . '<div class="item-photo-gallery__image-wrap"><img id="item-photo-gallery-image" alt=""><div id="item-photo-gallery-fallback" class="item-photo-gallery__fallback" role="img" aria-label="Photo unavailable" hidden>N/A</div></div>'
        . '<button class="item-photo-gallery__arrow" type="button" data-gallery-next aria-label="Next photo">›</button>'
        . '</div><p class="item-photo-gallery__count" id="item-photo-gallery-count" aria-live="polite"></p>'
        . '</div></dialog>';
}
