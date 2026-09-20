# Regenerable Python tooling data — hatch environments and the uv cache.
#
# Both default to locations that grow without bound: a project like coordinatai
# with ~50 git worktrees gets one hatch env tree per worktree per sub-project per
# env (default/test/lint), which reached 38G, while the uv cache reached 39G.
# Neither is hardlinked to the other, so they cost real disk twice over.
#
# Pointing both under ~/Library/Caches buys two things: Time Machine skips that
# directory automatically, and macOS can reclaim it as purgeable space under
# pressure. Everything here rebuilds on demand, so it is always safe to delete.
export DEV_CACHE="$HOME/Library/Caches/dev"
export UV_CACHE_DIR="$DEV_CACHE/uv"

# Make hatch install with uv rather than pip. hatch has no "use uv" flag, but
# setting an explicit uv path switches the virtual env type over to it
# (hatch/env/virtual.py: use_uv = installer == "uv" or bool(explicit_uv_path)).
#
# This matters more than where the files live. pip copies every wheel into every
# environment; uv clones them from its cache, and APFS clones share blocks. A
# second worktree building the same environment measured 2 MB against pip's
# 130 MB. Across ~50 worktrees that is the difference between 19G and ~1G for a
# single sub-project. It only works while $UV_CACHE_DIR and the hatch env
# directory sit on the same filesystem, so move them together.
command -v uv >/dev/null && export HATCH_ENV_TYPE_VIRTUAL_UV_PATH="$(command -v uv)"

# hatch has no env var for dirs.env, so its side is set in hatch/config.toml,
# which uses $HOME rather than $DEV_CACHE. hatch expands the path with
# os.path.expandvars in its own process, and an unset variable would expand to a
# literal directory named "$DEV_CACHE". Keep the two in sync if this moves.

devcache() {
    local root="${DEV_CACHE:?DEV_CACHE not set}"
    case "${1:-size}" in
        path) echo "$root" ;;
        size)
            [[ -d "$root" ]] || { echo "$root does not exist yet"; return 0; }
            du -sh "$root"/* 2>/dev/null | sort -rh
            echo "---"
            du -sh "$root" 2>/dev/null
            ;;
        prune)
            # Non-destructive: drops only entries nothing references.
            command -v uv >/dev/null && uv cache prune
            ;;
        purge)
            # Destructive: everything rebuilds on next hatch/uv run.
            echo "About to delete $root (everything under it rebuilds on demand)."
            du -sh "$root" 2>/dev/null
            read "reply?Proceed? [y/N] "
            [[ "$reply" == [yY] ]] || { echo "aborted"; return 1; }
            rm -rf "${root:?}"/*
            echo "purged $root"
            ;;
        *) echo "usage: devcache [size|path|prune|purge]"; return 2 ;;
    esac
}
