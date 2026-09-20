# Dotfiles

A collection of my `.dotfiles` including a [setup](setup.sh) script. This script
will setup all the things.

## Usage

### Clone down to your `$HOME` folder

```bash
cd ~
git clone https://github.com/ninowalker/dotfiles .dotfiles --recursive
```

### Setup

The following will be setup using this method:

- dotfiles
- Python
- Brew

```bash
cd ~/.dotfiles
./install
```

## Various Setting Info

### .bashrc and .bash_profile

To make these portable between `Linux` and `MacOS` we need to use both. The
reason is that for `MacOS` the default is to use `.bash_profile` and ignore
`.bashrc` whereas on `Linux` `.bash_profile` is only used for interactive
logins (ssh, terminal, and etc.) and ignored from GUI based terminal sessions.

And then we can add all of our goodies to `.bashrc`. And in doing so,
everything works as planned in all scenarios between `Linux` and `MacOS`.

### .gitconfig

Make sure to reset the user and email. Or you'll be using mine.

### launchd

Notes on finding and disabling macOS background agents and daemons, plus a log of what is
disabled on my machines, are in [OSX/launchd.md](OSX/launchd.md).

### Python tooling disk usage

hatch environments and the uv cache both default to locations that grow without bound. On a
project with ~50 git worktrees they reached 38G and 39G respectively, and they are not
hardlinked to each other, so the cost is paid twice.

Both are redirected under `~/Library/Caches/dev`, which Time Machine skips and macOS can
reclaim as purgeable space:

- uv, via `UV_CACHE_DIR` in [Python/devcache.zsh](Python/devcache.zsh).
- hatch, via `dirs.env.virtual` in [hatch/config.toml](hatch/config.toml), linked into place
  by dotbot. hatch has no environment variable for that setting.

`devcache` inspects and clears it: `devcache size`, `devcache prune` (drops only unreferenced
uv entries), `devcache purge` (deletes everything; it all rebuilds on demand).

Relocating does not reclaim anything by itself. Three things keep it down:

1. **hatch installs with uv.** `HATCH_ENV_TYPE_VIRTUAL_UV_PATH` switches hatch off pip. pip
   copies every wheel into every environment; uv clones from its cache and APFS clones share
   blocks. Measured on a second worktree of the same project: 2 MB against pip's 130 MB. This
   is the setting that matters. It needs the uv cache and the hatch env directory on the same
   filesystem, so move them together.
2. **`devcache-gc`** deletes environments whose project directory is gone. hatch names them
   by a hash of the project path and keeps no record of the original, so a deleted worktree
   leaves an unattributable directory behind. The script recomputes the hash for live projects
   and removes whatever matches none of them. `--delete` to act, otherwise it reports.
3. **Fewer worktrees.** Each one costs a set of environments per sub-project. Even deduplicated
   they are not free.

## Visual Studio Code Extensions

You can find some VS Code extensions exported [here](Code/extensions.list) which
you can easily import if you would like by executing the following:

```bash
cat $HOME/.dotfiles/Code/extensions.list | xargs -L1 code --install-extension
```

## Fonts

https://www.nerdfonts.com/font-downloads - Fira Nerd Code

https://github.com/agnoster/agnoster-zsh-theme/issues/23

## License

MIT

## Author Information

Nino Walker

This is derivative work. See the license, and the original repository: <https://github.com/mrlesmithjr/dotfiles>
