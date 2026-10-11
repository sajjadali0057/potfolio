from pathlib import Path

root = Path(__file__).resolve().parents[1]
exts = {".dart", ".yaml", ".py", ".md"}
skip = {".git", "build", ".dart_tool"}

updated = 0
for path in root.rglob("*"):
    if path.suffix.lower() not in exts:
        continue
    if any(part in skip for part in path.parts):
        continue
    text = path.read_text(encoding="utf-8")
    new = text
    # Restore flattened keys used briefly during the mistaken flatten pass.
    if "images/" not in new:
        new = new.replace("images/portfolio/", "images/portfolio/")
        new = new.replace("images/profile/", "images/profile/")
    if "branding/" not in new:
        new = new.replace("'branding/", "'branding/")
        new = new.replace('"branding/', '"branding/')
    new = new.replace("- images/", "- images/")
    new = new.replace("- branding/", "- branding/")
    new = new.replace("File('images/", "File('images/")
    if new != text:
        path.write_text(new, encoding="utf-8")
        updated += 1
        print(path.relative_to(root).as_posix())

print(f"updated={updated}")
