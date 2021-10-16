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

## Visual Studio Code Extensions

You can find some VS Code extensions exported [here](Code/extensions.list) which
you can easily import if you would like by executing the following:

```bash
cat $HOME/.dotfiles/Code/extensions.list | xargs -L1 code --install-extension
```

## License

MIT

## Author Information

Nino Walker

This is derivative work. See the license, and the original repository: <https://github.com/mrlesmithjr/dotfiles>
