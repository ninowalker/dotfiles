# Python Poetry settings
# https://python-poetry.org/docs/master/configuration/#using-environment-variables
export POETRY_VIRTUALENVS_IN_PROJECT=true
export PYENV_ROOT="$HOME/.pyenv"

ipyenv() {
    export PATH="$PYENV_ROOT/bin:$PATH"
    unalias pyenv 2>/dev/null || true
    which pyenv >/dev/null && eval "$(pyenv init --path)" && eval "$(pyenv init -)"
    pyenv "$@"
}

alias pyenv=ipyenv

# add pipx path
add_to_path -a "$HOME/.local/bin"
