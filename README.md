# unix-home
Configuration scripts of UNIX environment --- home feelings!

## Before installation

This set of configuration scripts/rc-files are supposed to be deployed on a fresh created home directory. If you already have some old rc files, please make backups! Effected files list:
  
    .bash_profile
    .bashrc
    .cshrc
    .gitconfig
    .screenrc
    .tmux.conf
    .vimrc

## Installation

Run script `install.sh`. You can `cd` into the directory or not --- things will go where they should go. During the installation, your git informations will be collected, which are your full name and email address.

## Features

### Bash prompt

A fancy command prompt:

 - username@hostname comes first in green (or red if you are root).

 - Yellow flashing "&N" indicates the number of background processes, hidden if N == 0.

 - Magenta "^N" indicates the shell level ($SHLVL), hidden if N == 0.

 - git-repo-root-dir-name[current-branch] indicates current git context, hidden if not in any repo, "(git)" if in `.git` directory.

 - Blue cwd followed by a line break.

 - Physical full pwd (if `$(pwd)` != `$(pwd -P)`) which is very dark.

 - Highlighted "$" (or "#" if you are root).

 - YOUR COMMAND goes here.

 - Each pipe level command appears here, fully expanded in absolute path and begin-of-execution timestamp, in very dary color.

 - Command status and complete timestamp. Red exception code of each pipe level if not all zero, otherwise green.

### Tmux appearance enhancement

Session name, hostname, date/time, system load in status bar. Colors adjusted. Red window tab indicates prefix key activation.

Remapped keys:

    Prefix key: Ctrl+J
    Vertical split: Prefix |
    Horizontal split: Prefix -
    Show pane number: Prefix Space

### Git configurations

Supports git command line aliases:

    # a fancy git log
    git h
    
    # git status -s
    git s
    
    # Many others please see dot_files/gitconfig
    
Two-level rc.

### Vim configurations

Key mappings and two-level rc.

### Screen configurations

Limited support.

### Csh prompt

Limited support. A slightly engineered prompt and two-level rc.

## Two-level rc

