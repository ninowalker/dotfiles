_do_snapshot() {
    local cmd=$1
    local list=$2
    if [ -x "$(command -v $cmd)" ] && [[ "$(uname)" = "Linux" ]]; then
        if [ ! -f "$list" ] || [[ $(find "$list" -mtime +1 -print) ]]; then
            return 0
        fi
    fi
    return 1
}

_do_snapshot snap "$HOME"/.dotfiles/ubuntu/snap.list && \
    snap list | sed '1d' | awk '{print $1}' > "$HOME"/.dotfiles/ubuntu/snap-installed.list

_do_snapshot apt-mark "$HOME"/.dotfiles/ubuntu/packages.list && \
    comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u) > "$HOME"/.dotfiles/ubuntu/packages.list

unset -f _do_snapshot

# https://garywoodfine.com/use-pbcopy-on-ubuntu/
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'