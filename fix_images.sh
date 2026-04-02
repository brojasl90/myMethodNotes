#!/bin/bash
# Fix Obsidian wikilink image references for MkDocs
# Run from: ~/Syncthing/masterDoc/myMethodology

set -e
DOCS="docs"
PICS="$DOCS/PICS"

echo "=== Step 1: Copying all Pasted images into docs/PICS/ ==="

mkdir -p "$PICS"

# Find all Pasted images anywhere under ~/Syncthing/masterDoc and copy to docs/PICS/
find ~/Syncthing/masterDoc -name "Pasted image*.png" -o -name "Pasted image*.jpg" 2>/dev/null | while read src; do
    filename=$(basename "$src")
    dest="$PICS/$filename"
    if [ ! -f "$dest" ]; then
        cp "$src" "$dest"
        echo "  Copied: $filename"
    else
        echo "  Exists: $filename"
    fi
done

echo ""
echo "=== Step 2: Replacing Obsidian wikilinks with standard Markdown ==="

# Find all .md files containing ![[
grep -rl '!\[\[' "$DOCS" --include="*.md" | while read mdfile; do
    echo "  Processing: $mdfile"

    # Determine relative path depth to calculate correct relative path to PICS
    # Count slashes to determine depth from docs/
    depth=$(echo "$mdfile" | sed "s|$DOCS/||" | tr -cd '/' | wc -c)

    # Build relative prefix (e.g. depth=1 → "../PICS", depth=2 → "../../PICS")
    prefix=""
    for i in $(seq 1 $depth); do
        prefix="../$prefix"
    done
    prefix="${prefix}PICS"

    # Replace ![[path/to/Pasted image 20XXXXXX.png]] with ![](../PICS/Pasted image 20XXXXXX.png)
    # Handles: ![[Pasted image 20...png]]
    # Handles: ![[some/path/Pasted image 20...png]]
    python3 - "$mdfile" "$prefix" << 'PYEOF'
import re, sys

mdfile = sys.argv[1]
prefix = sys.argv[2]

with open(mdfile, 'r', encoding='utf-8') as f:
    content = f.read()

def replace_wikilink(match):
    inner = match.group(1)
    # Extract just the filename (basename)
    filename = inner.split('/')[-1]
    return f'![]({prefix}/{filename})'

new_content = re.sub(r'!\[\[([^\]]+)\]\]', replace_wikilink, content)

if new_content != content:
    with open(mdfile, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print(f'    Fixed wikilinks in: {mdfile}')
PYEOF

done

echo ""
echo "=== Step 3: Summary ==="
echo "Images in docs/PICS/:"
ls "$PICS" | wc -l

echo ""
echo "Remaining broken wikilinks (should be 0):"
grep -r '!\[\[' "$DOCS" --include="*.md" | wc -l

echo ""
echo "Done. Run: mkdocs build"
