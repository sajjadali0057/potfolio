"""Create a Linux/cPanel-safe zip of build/web using forward-slash paths."""

from __future__ import annotations

import sys
import zipfile
from datetime import date
from pathlib import Path


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    web = root / "build" / "web"
    if not (web / "index.html").is_file():
        print("Missing build/web/index.html — run flutter build web first.", file=sys.stderr)
        return 1

    # Guard: nested assets/assets breaks some cPanel extracts with Permission denied.
    if (web / "assets" / "assets").exists():
        print("ERROR: build has nested assets/assets — flatten source keys first.", file=sys.stderr)
        return 1

    out = Path.home() / "Downloads" / f"sajjad-ali-portfolio-cpanel-{date.today().isoformat()}.zip"
    if out.exists():
        out.unlink()

    required = [
        web / "index.html",
        web / ".htaccess",
        web / "main.dart.js",
        web / "flutter_bootstrap.js",
        web / "brand" / "sajjad-ali-italic-logo-transparent.png",
        web / "icons" / "Icon-192-italic.png",
        web / "icons" / "Icon-512-italic.png",
        web / "assets" / "images" / "profile" / "sajjad-ali.png",
        web / "assets" / "branding" / "sajjad-ali-italic-logo-transparent.png",
        web / "assets" / "branding" / "codewend-wordmark.png",
        web / "assets" / "AssetManifest.bin.json",
        web / "resume" / "Sajjad_Ali_Resume.pdf",
    ]
    missing = [str(p.relative_to(root)) for p in required if not p.exists()]
    if missing:
        print("Missing required deploy files:", file=sys.stderr)
        for item in missing:
            print(f"  - {item}", file=sys.stderr)
        return 1

    count = 0
    with zipfile.ZipFile(out, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for path in sorted(web.rglob("*")):
            if not path.is_file():
                continue
            arcname = path.relative_to(web).as_posix()
            zf.write(path, arcname)
            count += 1

    with zipfile.ZipFile(out, "r") as zf:
        names = zf.namelist()
        bad = [n for n in names if "\\" in n]
        nested = [n for n in names if n.startswith("assets/assets/")]
        images = [n for n in names if n.startswith("assets/images/")]

    print(f"ZIP {out}")
    print(f"FILES {count}")
    print(f"SIZE_MB {out.stat().st_size / (1024 * 1024):.2f}")
    print(f"ASSET_IMAGES {len(images)}")
    print(f"NESTED_ASSETS {len(nested)}")
    print(f"BACKSLASH_PATHS {len(bad)}")
    for probe in (
        ".htaccess",
        "assets/images/profile/sajjad-ali.png",
        "assets/branding/sajjad-ali-italic-logo-transparent.png",
        "brand/sajjad-ali-italic-logo-transparent.png",
        "icons/Icon-192-italic.png",
        "icons/Icon-512-italic.png",
        "index.html",
    ):
        print(f"HAS {probe}={'yes' if probe in names else 'NO'}")
    return 0 if not bad and not nested else 2


if __name__ == "__main__":
    raise SystemExit(main())
