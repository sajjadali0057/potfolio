import zipfile
from pathlib import Path
zpath = Path.home()/"Downloads"/"sajjad-ali-portfolio-cpanel-2026-10-04.zip"
with zipfile.ZipFile(zpath) as z:
    names = z.namelist()
    print("backslash", sum("\\" in n for n in names))
    for p in [
        "images/profile/sajjad-ali.png",
        "branding/sajjad-ali-italic-logo-transparent.png",
        "assets/AssetManifest.bin.json",
        "brand/sajjad-ali-italic-logo-transparent.png",
    ]:
        print(p, "OK" if p in names else "MISSING")
    raw = z.read("assets/AssetManifest.bin.json").decode("utf-8", "replace")
    for key in [
        "images/profile/sajjad-ali.png",
        "branding/sajjad-ali-italic-logo-transparent.png",
    ]:
        print("manifest_has", key, key in raw)
