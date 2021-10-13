if [[ $(uname) == "Darwin" ]]; then
	# Add color to folders/files
	alias ls='ls -G'

	if [ -f "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
		# shellcheck disable=SC1094
		source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	fi

	if [ -f "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
		# shellcheck disable=SC1094
		source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	fi
	# shellcheck source=/dev/null
	test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

	export PATH="/usr/local/sbin:$PATH"
fi
