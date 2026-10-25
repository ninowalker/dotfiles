#!/usr/bin/env bash
# Packages the shell config depends on, and the Powerlevel10k font for the local terminal.
# Over SSH the prompt is drawn with the Mac terminal's font, so the font only matters at the laptop.
set -euo pipefail

sudo apt-get update
# fzf: the oh-my-zsh fzf plugin and bin/cdirs. git-lfs: .gitconfig requires the lfs filter.
sudo apt-get install -y zsh fzf git-lfs curl fontconfig

fonts="$HOME/.local/share/fonts"
mkdir -p "$fonts"
for style in Regular Bold Italic "Bold Italic"; do
	file="MesloLGS NF $style.ttf"
	[[ -f "$fonts/$file" ]] && continue
	curl -fsSL -o "$fonts/$file" "https://github.com/romkatv/powerlevel10k-media/raw/master/${file// /%20}"
done
fc-cache -f "$fonts"
