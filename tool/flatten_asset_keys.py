from pathlib import Path
import shutil

root = Path(r"c:\Users\sajja\Downloads\sajjad-ali-portfolio")

# Move assets/images -> images, assets/branding -> branding
src_images = root / "assets" / "images"
src_branding = root / "assets" / "branding"
dst_images = root / "images"
dst_branding = root / "branding"

if src_images.exists():
    if dst_images.exists():
        shutil.rmtree(dst_images)
    shutil.move(str(src_images), str(dst_images))
if src_branding.exists():
    if dst_branding.exists():
        shutil.rmtree(dst_branding)
    shutil.move(str(src_branding), str(dst_branding))

# Clean empty assets dir if empty
assets = root / "assets"
if assets.exists() and not any(assets.iterdir()):
    assets.rmdir()

# Rewrite source references
exts = {".dart", ".yaml", ".py", ".md"}
skip = {".git", "build", ".dart_tool"}
updated = []
for path in root.rglob("*"):
    if path.suffix.lower() not in exts:
        continue
    if any(p in skip for p in path.parts):
        continue
    text = path.read_text(encoding="utf-8")
    new = text.replace("images/", "images/").replace("branding/", "branding/")
    if new != text:
        path.write_text(new, encoding="utf-8")
        updated.append(path.relative_to(root).as_posix())

print("images", (root / "images" / "profile" / "sajjad-ali.png").exists())
print(
    "branding",
    (root / "branding" / "sajjad-ali-italic-logo-transparent.png").exists(),
)
print("updated", len(updated))
for u in updated:
    print(" ", u)
