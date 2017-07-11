# .files

Those are dotfiles that I use

_Disclaimer : I take no responsibility on this working at yout machine_

## What are those?

Those are configs that help me live better. Here they are listed:

### .tmux.conf

Configuration for tmux.

#### How to use?

Place it at your home directory, or make a symlink there, like this `ln -s <where-repo-is>/.tmux.conf ~/.tmux.conf`

### .vimrc

A configuration for vim I use.

_Note_: I use [vim-plug](https://github.com/junegunn/vim-plug) as a plugin manager. Install it, if you want to use it

#### How to use?

The same, as .tmux.conf

### awesome

This is a config for awesome window manager. Mostly, edited default configuration, but I added some little things from myself.
For it to correctly, `volumeicon`, `xscreensaver`, `xfce4-terminal`, `network-manager-applets`, and awesome `vicious` plugins are required.

#### How to use?

Place it at `~/.config`

### roj.sh

A little project manager based on tmux sessions. To use it, ensure the `workspace` dir existanse in home directory and tmux installed.

#### How to use?

Copy the `roj.sh` to place in your PATH and run `roj.sh <project-name>`. If project exists, the tmux session will be started in directory of project. If session is already started, it will attach it. If directory doesn't exist, it'll be created

### redshift.conf

My configuration of redshift.

#### How to use?

Place at `~/.config`
