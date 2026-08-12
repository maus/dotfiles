# Setup

Notes to future self.

## Get the boilerplate

After cloning the repo in your home (~), create or update ~/.bash_profile to:
`. /home/maus/.dotfiles/.bash_profile`

If you use vim, do the same with ~/.vimrc, except:
`cd ~ && ln -s .dotfiles/.vimrc .vimrc`

## Machine specific

Anything that's specific to the machine you're on goes into the default dotfiles.

If the machine's own `~/.bash_aliases` is also sourced by the OS default `~/.bashrc` (as Debian/Ubuntu's stock one is), make its first line `export BASH_ALIASES_LOADED=1`. `~/.bash_profile` checks that variable before sourcing `~/.bash_aliases` itself, so the alias file doesn't get loaded twice — once via `~/.bashrc` on a non-login shell, and again via `~/.bash_profile` on a login shell.