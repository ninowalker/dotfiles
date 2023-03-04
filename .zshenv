# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout

# .zshenv is always sourced, it often contains exported variables that should be available to other programs.
# For example, $PATH, $EDITOR, and $PAGER are often set in .zshenv

# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
export ZSH=$HOME/.dotfiles

if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

setopt nullglob
typeset -U dot_config_files
dot_config_files=($ZSH/**/env.zsh(on) $HOME/.*.dotfiles/**/env.zsh(Non))
# load the path files
for file in ${(M)dot_config_files}
do
  source $file
done

unset dot_config_files
