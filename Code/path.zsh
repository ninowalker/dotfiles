# Capture existing VSCode extensions
# Skip if running in WSL or if updated in the last day
if [ -x "$(command -v code)" ] && [[ "$(uname -r)" != *"microsoft"* ]]; then
    if [[ $(find "$HOME"/.dotfiles/Code/extensions.list -mtime +1 -print) ]]; then
        code --list-extensions > "$HOME"/.dotfiles/Code/extensions.list
    fi
fi
