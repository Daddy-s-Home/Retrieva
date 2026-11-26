<?php
declare(strict_types=1);

final class RetrievaPdf {
    private string $ops = '';
    private array $contents = [];
    private float $y = 730;
    private int $page = 0;

    public function __construct(private string $title, private string $subtitle) {
        $this->startPage(true);
    }

    public function kpis(array $items): void {
        $count = max(1, count($items));
        $gap = 8;
        $width = (532 - ($gap * ($count - 1))) / $count;
        $this->ensure(58);
        $bottom = $this->y - 48;
        $x = 40;
        foreach ($items as $item) {
            $this->box($x, $bottom, $width, 48, [243, 246, 251]);
            $this->text($x + 8, $bottom + 26, (string) $item['value'], 14, [11, 42, 92]);
            $this->text($x + 8, $bottom + 10, (string) $item['label'], 9, [80, 90, 104]);
            $x += $width + $gap;
        }
        $this->y = $bottom - 16;
    }

    public function bars(string $heading, array $labels, array $series): void {
        $this->ensure(150);
        $this->text(40, $this->y, $heading, 12, [11, 42, 92]);
        $this->y -= 8;
        $height = 100;
        $bottom = $this->y - $height;
        $this->box(40, $bottom, 532, $height, [255, 255, 255]);
        $max = 1;
        foreach ($series as $set) {
            foreach ($set['values'] as $value) {
                $max = max($max, (int) $value);
            }
        }
        $groups = max(1, count($labels));
        $groupWidth = 500 / $groups;
        $barWidth = min(12, max(2, ($groupWidth - 6) / max(1, count($series))));
        $plotBottom = $bottom + 16;
        $plotHeight = 70;
        foreach ($labels as $index => $label) {
            $x = 52 + ($index * $groupWidth);
            foreach ($series as $setIndex => $set) {
                $value = (int) ($set['values'][$index] ?? 0);
                $barHeight = max(0, ($value / $max) * $plotHeight);
                $this->box($x + ($setIndex * ($barWidth + 1)), $plotBottom, $barWidth, $barHeight, $set['color']);
            }
            if ($groups <= 16 || $index % (int) ceil($groups / 12) === 0) {
                $this->text($x, $bottom + 4, $this->fit((string) $label, max(12, $groupWidth - 2), 7), 7, [80, 90, 104]);
            }
        }
        $legendX = 40;
        $this->y = $bottom - 14;
        foreach ($series as $set) {
            $this->box($legendX, $this->y, 8, 8, $set['color']);
            $this->text($legendX + 12, $this->y, (string) $set['name'], 8, [40, 48, 60]);
            $legendX += 70;
        }
        $this->y -= 18;
    }

    public function table(array $headers, array $rows): void {
        if ($headers === []) {
            return;
        }
        $this->text(40, $this->y, 'Records', 12, [11, 42, 92]);
        $this->y -= 16;
        $widths = $this->widths(count($headers));
        $this->headerRow($headers, $widths);
        if ($rows === []) {
            $this->text(40, $this->y, 'No rows in this range.', 10, [80, 90, 104]);
            return;
        }
        foreach ($rows as $index => $row) {
            $this->ensure(18);
            if ($this->y < 64) {
                $this->startPage(false);
                $this->headerRow($headers, $widths);
            }
            $bottom = $this->y - 14;
            if ($index % 2 === 0) {
                $this->box(40, $bottom, 532, 14, [243, 246, 251]);
            }
            $x = 40;
            foreach ($widths as $column => $width) {
                $this->text($x + 3, $bottom + 3, $this->fit((string) ($row[$column] ?? ''), $width - 6, 8), 8, [30, 36, 48]);
                $x += $width;
            }
            $this->y = $bottom;
        }
    }

    public function render(): string {
        $this->contents[] = $this->ops;
        $objects = [
            1 => '<< /Type /Catalog /Pages 2 0 R >>',
            3 => '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>',
        ];
        $pageIds = [];
        $next = 4;
        foreach ($this->contents as $stream) {
            $contentId = $next++;
            $pageId = $next++;
            $objects[$contentId] = "<< /Length " . strlen($stream) . " >>\nstream\n" . $stream . "\nendstream";
            $objects[$pageId] = "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents {$contentId} 0 R /Resources << /Font << /F1 3 0 R >> >> >>";
            $pageIds[] = $pageId . ' 0 R';
        }
        $objects[2] = '<< /Type /Pages /Kids [' . implode(' ', $pageIds) . '] /Count ' . count($pageIds) . ' >>';
        ksort($objects);
        $pdf = "%PDF-1.4\n";
        $offsets = [];
        $max = max(array_keys($objects));
        foreach ($objects as $id => $body) {
            $offsets[$id] = strlen($pdf);
            $pdf .= $id . " 0 obj\n" . $body . "\nendobj\n";
        }
        $xref = strlen($pdf);
        $count = $max + 1;
        $pdf .= "xref\n0 $count\n";
        $pdf .= "0000000000 65535 f \n";
        for ($id = 1; $id <= $max; $id++) {
            $pdf .= sprintf("%010d 00000 n \n", $offsets[$id] ?? 0);
        }
        $pdf .= "trailer << /Size $count /Root 1 0 R >>\nstartxref\n$xref\n%%EOF";
        return $pdf;
    }

    private function startPage(bool $first): void {
        if ($this->page > 0) {
            $this->contents[] = $this->ops;
        }
        $this->ops = '';
        $this->page++;
        $this->box(0, 756, 612, 36, [11, 42, 92]);
        $this->text(40, 768, 'Retrieva', 14, [255, 255, 255]);
        $this->text(120, 768, $this->title, 11, [201, 162, 39]);
        $this->y = 734;
        if ($first) {
            $this->text(40, $this->y, $this->subtitle, 10, [40, 48, 60]);
            $this->y -= 26;
        }
    }

    private function headerRow(array $headers, array $widths): void {
        $this->ensure(18);
        $bottom = $this->y - 16;
        $this->box(40, $bottom, 532, 16, [11, 42, 92]);
        $x = 40;
        foreach ($widths as $column => $width) {
            $this->text($x + 3, $bottom + 4, $this->fit((string) $headers[$column], $width - 6, 8), 8, [255, 255, 255]);
            $x += $width;
        }
        $this->y = $bottom;
    }

    private function widths(int $count): array {
        $each = 532 / max(1, $count);
        return array_fill(0, $count, $each);
    }

    private function ensure(float $need): void {
        if ($this->y - $need < 48) {
            $this->startPage(false);
        }
    }

    private function box(float $x, float $y, float $width, float $height, array $rgb): void {
        $this->ops .= sprintf(
            "%.3f %.3f %.3f rg\n%.2f %.2f %.2f %.2f re f\n",
            $rgb[0] / 255,
            $rgb[1] / 255,
            $rgb[2] / 255,
            $x,
            $y,
            $width,
            $height
        );
    }

    private function text(float $x, float $y, string $text, float $size, array $rgb): void {
        $this->ops .= sprintf(
            "%.3f %.3f %.3f rg\nBT /F1 %.1f Tf 1 0 0 1 %.2f %.2f Tm (%s) Tj ET\n",
            $rgb[0] / 255,
            $rgb[1] / 255,
            $rgb[2] / 255,
            $size,
            $x,
            $y,
            $this->escape($text)
        );
    }

    private function fit(string $text, float $width, float $size): string {
        $plain = $this->latin($text);
        $max = max(1, (int) floor($width / max(1, $size * 0.5)));
        if (strlen($plain) <= $max) {
            return $plain;
        }
        return substr($plain, 0, max(1, $max - 1)) . '.';
    }

    private function latin(string $text): string {
        $converted = iconv('UTF-8', 'Windows-1252//TRANSLIT//IGNORE', $text);
        if ($converted === false) {
            $converted = preg_replace('/[^\x20-\x7E]/', '', $text) ?? '';
        }
        return $converted;
    }

    private function escape(string $text): string {
        return str_replace(['\\', '(', ')'], ['\\\\', '\\(', '\\)'], $this->latin($text));
    }
}

function retrieva_pdf_build(array $doc): string {
    $pdf = new RetrievaPdf((string) $doc['title'], (string) $doc['subtitle']);
    $pdf->kpis($doc['kpis'] ?? []);
    foreach ($doc['charts'] ?? [] as $chart) {
        $pdf->bars((string) $chart['title'], $chart['labels'] ?? [], $chart['series'] ?? []);
    }
    $pdf->table($doc['headers'] ?? [], $doc['rows'] ?? []);
    return $pdf->render();
}
