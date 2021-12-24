__source_maybe() {
	if [ -f "$1" ]; then
		# shellcheck disable=SC1094
		source "$1"
	fi
}

if [[ $(uname) == "Darwin" ]]; then
	# Add color to folders/files
	alias ls='ls -G'
	__source_maybe /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	__source_maybe /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	__source_maybe "${HOME}/.iterm2_shell_integration.zsh"
	export PATH="/usr/local/sbin:$PATH"
fi

unset -f __source_maybe