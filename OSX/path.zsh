# Add Homebrew's site-functions to fpath for completions
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

# Capture existing brew formulae/casks
# Skip if running in WSL or if updated in the last day
if [ -x "$(command -v brew)" ] && [[ "$(uname)" = "Darwin" ]]; then
    local list="$HOME"/.dotfiles/OSX/casks.list
    if [ ! -f "$list" ] || [[ $(find "$list" -mtime +1 -print) ]]; then
        brew list --casks >"$list"
    fi
    local list="$HOME"/.dotfiles/OSX/formulae.list
    if [ ! -f "$list" ] || [[ $(find "$list" -mtime +1 -print) ]]; then
        brew list --formulae >"$list"
    fi
fi
