"""Generate compressed preview images for Flutter web delivery."""

from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image

PORTFOLIO_MAX_WIDTH = 960
PORTFOLIO_JPEG_QUALITY = 78
PROFILE_MAX_WIDTH = 900
PROFILE_JPEG_QUALITY = 80

IMAGE_SUFFIXES = {".png", ".jpg", ".jpeg", ".webp", ".gif"}


def repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def has_transparency(image: Image.Image) -> bool:
    if image.mode == "RGBA":
        return image.getextrema()[3][0] < 255
    if image.mode == "LA":
        return image.getextrema()[1][0] < 255
    if image.mode == "P":
        return "transparency" in image.info
    return False


def resize_to_max_width(image: Image.Image, max_width: int) -> Image.Image:
    width, height = image.size
    if width <= max_width:
        return image.copy()
    new_height = max(1, round(height * max_width / width))
    return image.resize((max_width, new_height), Image.Resampling.LANCZOS)


def choose_output_path(source: Path, preview_dir: Path) -> Path:
    stem = source.stem
    return preview_dir / f"{stem}.jpg"


def save_preview(
    source: Path,
    dest: Path,
    max_width: int,
    jpeg_quality: int,
) -> tuple[int, int]:
    with Image.open(source) as img:
        img.load()
        resized = resize_to_max_width(img, max_width)
        use_png = has_transparency(resized)
        dest.parent.mkdir(parents=True, exist_ok=True)

        if use_png:
            out_path = dest.with_suffix(".png")
            if resized.mode not in ("RGBA", "LA", "P"):
                resized = resized.convert("RGBA")
            resized.save(out_path, optimize=True)
        else:
            out_path = dest.with_suffix(".jpg")
            if resized.mode in ("RGBA", "LA", "P"):
                background = Image.new("RGB", resized.size, (255, 255, 255))
                background.paste(
                    resized,
                    mask=resized.split()[-1] if resized.mode in ("RGBA", "LA") else None,
                )
                resized = background
            elif resized.mode != "RGB":
                resized = resized.convert("RGB")
            resized.save(
                out_path,
                format="JPEG",
                quality=jpeg_quality,
                optimize=True,
                progressive=True,
            )

    source_bytes = source.stat().st_size
    preview_bytes = out_path.stat().st_size
    return source_bytes, preview_bytes


def should_skip_full_hd(source: Path, project_dir: Path) -> bool:
    if source.parent.name != "full-hd":
        return False
    sibling = project_dir / source.name
    return sibling.is_file()


def iter_portfolio_sources(portfolio_root: Path) -> list[Path]:
    sources: list[Path] = []
    for path in sorted(portfolio_root.rglob("*")):
        if not path.is_file():
            continue
        if path.suffix.lower() not in IMAGE_SUFFIXES:
            continue
        rel_parts = path.relative_to(portfolio_root).parts
        if "preview" in rel_parts:
            continue
        project_dir = portfolio_root / rel_parts[0]
        if should_skip_full_hd(path, project_dir):
            continue
        sources.append(path)
    return sources


def preview_dir_for(source: Path, portfolio_root: Path) -> Path:
    project_dir = portfolio_root / source.relative_to(portfolio_root).parts[0]
    return project_dir / "preview"


def format_bytes(num: int) -> str:
    value = float(num)
    for unit in ("B", "KB", "MB", "GB"):
        if value < 1024 or unit == "GB":
            if unit == "B":
                return f"{int(value)} {unit}"
            return f"{value:.2f} {unit}"
        value /= 1024
    return f"{num} B"


def main() -> int:
    root = repo_root()
    portfolio_root = root / "images" / "portfolio"
    profile_source = root / "images" / "profile" / "sajjad-ali.png"
    profile_preview_dir = root / "images" / "profile" / "preview"

    if not portfolio_root.is_dir():
        print("Missing images/portfolio/", file=sys.stderr)
        return 1

    created_dirs: set[Path] = set()
    total_source_bytes = 0
    total_preview_bytes = 0
    generated = 0

    for source in iter_portfolio_sources(portfolio_root):
        preview_dir = preview_dir_for(source, portfolio_root)
        dest = choose_output_path(source, preview_dir)
        src_b, prev_b = save_preview(
            source,
            dest,
            PORTFOLIO_MAX_WIDTH,
            PORTFOLIO_JPEG_QUALITY,
        )
        if preview_dir not in created_dirs and preview_dir.is_dir():
            created_dirs.add(preview_dir)
        total_source_bytes += src_b
        total_preview_bytes += prev_b
        generated += 1

    if profile_source.is_file():
        profile_dest = profile_preview_dir / "sajjad-ali.jpg"
        src_b, prev_b = save_preview(
            profile_source,
            profile_dest,
            PROFILE_MAX_WIDTH,
            PROFILE_JPEG_QUALITY,
        )
        if profile_preview_dir.is_dir():
            created_dirs.add(profile_preview_dir)
        total_source_bytes += src_b
        total_preview_bytes += prev_b
        generated += 1
    else:
        print(f"Warning: missing {profile_source.relative_to(root).as_posix()}", file=sys.stderr)

    print(f"Generated {generated} preview file(s).")
    print("Preview folders:")
    for folder in sorted(created_dirs, key=lambda p: p.as_posix()):
        print(f"  - {folder.relative_to(root).as_posix()}/")

    saved = total_source_bytes - total_preview_bytes
    pct = (saved / total_source_bytes * 100) if total_source_bytes else 0.0
    print()
    print("Byte summary (sources processed vs previews written):")
    print(f"  Original: {format_bytes(total_source_bytes)} ({total_source_bytes:,} bytes)")
    print(f"  Preview:  {format_bytes(total_preview_bytes)} ({total_preview_bytes:,} bytes)")
    print(f"  Saved:    {format_bytes(saved)} ({saved:,} bytes, {pct:.1f}% smaller)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
