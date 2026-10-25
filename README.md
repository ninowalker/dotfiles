# Dotfiles — ubuntu-26 branch

The shell and git setup from `main`, cut down for Ubuntu 26.04 (the XPS dev box). macOS,
Homebrew, VS Code, ssh, AWS, hatch, ngrok, pnpm and bash files are removed; `main` keeps them.

## Usage

```bash
git clone --recursive -b ubuntu-26 https://github.com/ninowalker/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
```

`./install` links the zsh, Powerlevel10k and git files into `~`, installs zsh, fzf, git-lfs and
the MesloLGS NF fonts ([ubuntu/setup.sh](ubuntu/setup.sh)), oh-my-zsh and Powerlevel10k, copies
the Claude Code security settings, sets zsh as the login shell and creates an SSH key if there
is none. It asks for sudo. It is safe to re-run.

## Various Setting Info

### .gitconfig

Make sure to reset the user and email. Or you'll be using mine.

### Claude Code security settings

[claude/managed-settings.d/dotfiles-security.json](claude/managed-settings.d/dotfiles-security.json)
denies Claude Code reads of credential files: SSH, AWS, GnuPG, gcloud, gh, docker and kube
config, `.netrc` and similar, Claude's own credentials, and any `.env` or `.env.*` file.
`./install` copies it, owned by root, into
`/etc/claude-code/managed-settings.d/`. After editing it, copy it again
with the same command from `install.conf.yaml`.

- Managed settings rank above user and project settings. Their deny rules add to the allow rules
  in `~/.claude/settings.json` rather than replacing them, and a deny beats any allow.
- It is copied rather than linked so an agent that can edit this repo cannot loosen the live
  rules. The file also denies edits to its source in the repo.
- A `Read` deny also covers `cat`, `grep` and similar commands run through Bash, but not every
  route: a command wrapped in `sh -c`, or a program that reads the file itself, gets through.
  Claude Code's sandbox (`sandbox.filesystem.denyRead`) enforces this at the OS level; it is not
  enabled here.
- `.env.*` also matches `.env.example`.
- The rest of `~/.claude` (settings, hooks, skills, history) is not tracked.

### Python tooling disk usage

hatch environments and the uv cache both default to locations that grow without bound. On a
project with ~50 git worktrees they reached 38G and 39G respectively, and they are not
hardlinked to each other, so the cost is paid twice.

The uv cache is redirected under `~/.cache/dev`:

- uv, via `UV_CACHE_DIR` in [Python/env.zsh](Python/env.zsh) and, for processes that never
  source a zsh profile, `cache-dir` in `~/.config/uv/uv.toml`. That file is generated at
  install time rather than tracked, because uv expands neither `~` nor `$HOME` inside it.
- hatch keeps its default location on this branch (`hatch/config.toml` is macOS-only).

The variables live in `env.zsh` rather than any other `*.zsh` on purpose: `.zshenv` sources
`$ZSH/**/env.zsh`, so they reach every zsh, while `.zshrc`'s glob would only reach interactive
ones and leave scripts, just recipes and editor tasks building in the default locations.

`devcache` inspects and clears it: `devcache size`, `devcache prune` (drops only unreferenced
uv entries), `devcache purge` (deletes everything; it all rebuilds on demand).

Relocating does not reclaim anything by itself. Three things keep it down:

1. **hatch installs with uv.** `HATCH_ENV_TYPE_VIRTUAL_UV_PATH` switches hatch off pip. pip
   copies every wheel into every environment; uv hardlinks from its cache on ext4 (clones on
   APFS). Measured on macOS on a second worktree of the same project: 2 MB against pip's 130 MB. This
   is the setting that matters. It needs the uv cache and the hatch env directory on the same
   filesystem, so move them together.
2. **`devcache-gc`** deletes environments whose project directory is gone. hatch names them
   by a hash of the project path and keeps no record of the original, so a deleted worktree
   leaves an unattributable directory behind. The script recomputes the hash for live projects
   and removes whatever matches none of them. `--delete` to act, otherwise it reports.
3. **Fewer worktrees.** Each one costs a set of environments per sub-project. Even deduplicated
   they are not free.

## Docker

[bin/dvol](bin/dvol) backs up and restores docker volumes by copying one volume into another
through a throwaway `alpine` container. File ownership and permissions are kept.

```bash
dvol backup pgdata                 # copies into pgdata-YYYYmmdd-HHMMSS
dvol backup pgdata pgdata-premigr  # copies into a name you choose
dvol restore pgdata-premigr pgdata # deletes pgdata and recreates it from the backup
```

- `backup` refuses to overwrite an existing volume. It warns, but continues, when a running
  container uses the source. Stop containers that write to it first, or the copy may be
  inconsistent.
- `restore` replaces the target instead of merging into it. It refuses while any container,
  running or stopped, uses the target, since docker cannot delete the volume then.
- Both refuse a source volume that does not exist. `docker run -v` would otherwise create an
  empty one and copy nothing.

[bin/dclean](bin/dclean) removes stopped containers (exited, or created and never started) and
dangling images. It lists them by default; `dclean --delete` removes them. It leaves volumes
alone.

## License

MIT

## Author Information

Nino Walker

This is derivative work. See the license, and the original repository: <https://github.com/mrlesmithjr/dotfiles>
