if [[ -d "$HOME"/powerlevel10k ]]; then
	source "$HOME"/powerlevel10k/powerlevel10k.zsh-theme
else
	# ZSH_THEME="robbyrussell"
	# ZSH_THEME="agnoster"
	# ZSH_THEME="af-magic"
	# ZSH_THEME="pygmalion"
	# shellcheck disable=SC2034
	#ZSH_THEME="avit"
	ZSH_THEME="ys"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
