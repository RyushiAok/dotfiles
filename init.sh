#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

for f in .??*; do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".github" ]] && continue
    [[ "$f" == ".github/workflows" ]] && continue
    [[ "$f" == ".config" ]] && continue
    [[ "$f" == ".rye" ]] && continue
    ln -snfv "$SCRIPT_DIR/$f" "$HOME/$f" 
done
 
function link_directory {
    local source_dir="$1"
    find "$source_dir" -type f ! -path '*.git*' | while IFS= read -r file; do 
        local dest_path="$HOME/${file#"$SCRIPT_DIR"/}"
        mkdir -p "$(dirname "$dest_path")"
        ln -snfv "$SCRIPT_DIR/$file" "$dest_path"
    done
}

link_directory ".config"
link_directory ".rye"
