# Regenerable Python tooling data — hatch environments and the uv cache.
#
# This file is named env.zsh deliberately: .zshenv sources $ZSH/**/env.zsh, so
# these apply to every zsh, not just interactive ones. .zshrc's glob would only
# cover interactive shells, which leaves scripts, just recipes and editor tasks
# building environments in the default locations.
#
# Both tools default to locations that grow without bound. A project with ~50
# git worktrees gets one hatch env tree per worktree per sub-project per env,
# which reached 38G, while the uv cache reached 39G. Neither is hardlinked to
# the other, so the cost is paid twice. ~/Library/Caches is skipped by Time
# Machine and reclaimable by macOS as purgeable space, and everything here
# rebuilds on demand.
export DEV_CACHE="$HOME/Library/Caches/dev"
export UV_CACHE_DIR="$DEV_CACHE/uv"

# Make hatch install with uv rather than pip. hatch has no "use uv" flag and no
# global config field for it — its config.toml only carries mode, project,
# shell, dirs, projects, publish, template and terminal — but setting an
# explicit uv path switches the virtual env type over:
#   use_uv = installer == "uv" or bool(explicit_uv_path)   (hatch/env/virtual.py)
#
# This matters more than where the files live. pip copies every wheel into every
# environment; uv clones them from its cache, and APFS clones share blocks. A
# second worktree building the same environment measured 2 MB against pip's
# 130 MB. It only holds while $UV_CACHE_DIR and the hatch env directory sit on
# one filesystem, so move them together.
#
# $commands is zsh's hash of external commands, so this costs no subshell on a
# file that every zsh invocation sources.
[[ -n "${commands[uv]}" ]] && export HATCH_ENV_TYPE_VIRTUAL_UV_PATH="${commands[uv]}"
