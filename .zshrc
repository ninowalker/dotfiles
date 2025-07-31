# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
# .zshrc is for interactive shell configuration.

export ZSH=$HOME/.oh-my-zsh

# Path to your dotfiles installation.
export DOTFILES_DIR="$HOME/.dotfiles"

# skip the verification of insecure directories
# shellcheck disable=SC2034
ZSH_DISABLE_COMPFIX="true"

# # shellcheck source=/dev/null
source "$ZSH"/oh-my-zsh.sh

# your project folder that we can `c [tab]` to
# export PROJECTS=~/dev/platform
export ZSH=$HOME/.dotfiles

# all of our zsh files
setopt nullglob
typeset -U config_files
config_files=($ZSH/**/*.zsh $HOME/.*.dotfiles/**/*.zsh(N))

# load the path files
for file in ${(M)config_files:#*/path.zsh}
do
  source $file
done

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
do
  source $file
done

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}
do
  source $file
done

unset config_files

# Better history
# Credits to https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

. "$HOME/.grit/bin/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/rfc/.cache/lm-studio/bin"

# Added by Windsurf
export PATH="/Users/rfc/.codeium/windsurf/bin:$PATH"
