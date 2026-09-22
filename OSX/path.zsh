# Add Homebrew's site-functions to fpath for completions
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

# Record installed taps, formulae and casks in OSX/Brewfile once a day, in the
# background because a dump takes a second or two. The Brewfile lists only
# formulae marked as installed on request, so dependencies stay out of it;
# clear that mark with `brew tab --no-installed-on-request <formula>`.
if [[ -n "${commands[brew]}" ]]; then
    () {
        local brewfile="$HOME/.dotfiles/OSX/Brewfile"
        if [[ ! -f "$brewfile" || -n $(find "$brewfile" -mtime +1 -print) ]]; then
            HOMEBREW_NO_AUTO_UPDATE=1 brew bundle dump --file="$brewfile" --force \
                --no-describe --tap --formula --cask &>/dev/null &!
        fi
    }
fi
