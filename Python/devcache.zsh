# Inspect and clear the regenerable Python tooling data. The variables this uses
# are exported from Python/env.zsh; this file only adds an interactive helper.
#
# The uv cache side is also written to ~/.config/uv/uv.toml by the installer, so
# that processes which never source a zsh profile still find it. hatch cannot be
# covered that way — see the note in Python/env.zsh.
devcache() {
    local root="${DEV_CACHE:?DEV_CACHE not set — is Python/env.zsh sourced?}"
    case "${1:-size}" in
        path) echo "$root" ;;
        size)
            [[ -d "$root" ]] || { echo "$root does not exist yet"; return 0 }
            du -sh "$root"/* 2>/dev/null | sort -rh
            echo "---"
            du -sh "$root" 2>/dev/null
            ;;
        prune)
            # Non-destructive: drops only entries nothing references.
            [[ -n "${commands[uv]}" ]] && uv cache prune
            ;;
        purge)
            # Destructive: everything rebuilds on next hatch/uv run.
            echo "About to delete the contents of $root (all of it rebuilds on demand)."
            du -sh "$root" 2>/dev/null
            read "reply?Proceed? [y/N] "
            [[ "$reply" == [yY] ]] || { echo "aborted"; return 1 }
            rm -rf "${root:?}"/*
            echo "purged $root"
            ;;
        *) echo "usage: devcache [size|path|prune|purge]"; return 2 ;;
    esac
}
