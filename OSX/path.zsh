# Capture existing VSCode extensions
# Skip if running in WSL or if updated in the last day
if [ -x "$(command -v brew)" ] && [[ "$(uname)" = "Darwin" ]]; then
    local list="$HOME"/.dotfiles/OSX/casks.list
    if [ ! -f "$list" ] || [[ $(find "$list" -mtime +1 -print) ]]; then
        brew list --casks > "$list"
    fi
    local list="$HOME"/.dotfiles/OSX/formulae.list
    if [ ! -f "$list" ] || [[ $(find "$list" -mtime +1 -print) ]]; then
        brew list --formulae > "$list"
    fi
fi

organize_files() {
    extensions=($(ls -dp *.* | perl -pe 's/.*\.//' | sort -u | grep -v '/$'))
    echo "$extensions" | tr 'A-Z' 'a-z' | xargs mkdir -p 
    for ext in "${extensions[@]}"; do
        lxt=$(echo $ext | tr 'A-Z' 'a-z')
        mv *.$ext $lxt
    done
}
