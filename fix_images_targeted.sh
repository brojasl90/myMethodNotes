#!/bin/bash
# Targeted image fix — only copies images actually referenced in docs/
# Run from: ~/Syncthing/masterDoc/myMethodology

DOCS="docs"
PICS="$DOCS/PICS"
SEARCH_ROOT=~/Syncthing/masterDoc

echo "=== Step 1: Finding all image references in docs/ ==="

# Extract just the filenames from all ![[...]] references
grep -r '!\[\[' "$DOCS" --include="*.md" | \
  grep -oP '!\[\[.*?\]\]' | \
  sed "s/!\[\[//" | sed "s/\]\]//" | \
  awk -F'/' '{print $NF}' | \
  sort -u > /tmp/required_images.txt

echo "Found $(wc -l < /tmp/required_images.txt) unique image references:"
cat /tmp/required_images.txt

echo ""
echo "=== Step 2: Finding and copying only those images ==="

while read imgname; do
    # Search only under masterDoc for this specific filename
    found=$(find "$SEARCH_ROOT" -name "$imgname" 2>/dev/null | head -1)
    if [ -n "$found" ]; then
        cp "$found" "$PICS/$imgname"
        echo "  Copied: $imgname"
    else
        echo "  NOT FOUND: $imgname"
    fi
done < /tmp/required_images.txt

echo ""
echo "=== Step 3: Fixing wikilinks in .md files ==="

grep -rl '!\[\[' "$DOCS" --include="*.md" | while read mdfile; do
    depth=$(echo "$mdfile" | sed "s|$DOCS/||" | tr -cd '/' | wc -c)
    prefix=""
    for i in $(seq 1 $depth); do
        prefix="../$prefix"
    done
    prefix="${prefix}PICS"

    python3 - "$mdfile" "$prefix" << 'PYEOF'
import re, sys
mdfile = sys.argv[1]
prefix = sys.argv[2]

with open(mdfile, 'r', encoding='utf-8') as f:
    content = f.read()

def replace_wikilink(match):
    inner = match.group(1)
    filename = inner.split('/')[-1]
    return f'![]({prefix}/{filename})'

new_content = re.sub(r'!\[\[([^\]]+)\]\]', replace_wikilink, content)

if new_content != content:
    with open(mdfile, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print(f'    Fixed: {mdfile}')
PYEOF
done

echo ""
echo "=== Step 4: Summary ==="
echo "Images in docs/PICS/: $(ls $PICS | wc -l)"
echo "Remaining broken wikilinks: $(grep -r '!\[\[' $DOCS --include='*.md' | wc -l)"
echo ""
echo "Done. Run: mkdocs build"
