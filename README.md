# unix-home: An easy management system of Unix rc/dot -files

Configuration scripts of Unix environment.

![alt tag](https://github.com/hengyang-zhao/unix-home/blob/master/images/full-demo.gif)

## Before installation

This set of configuration scripts/rc-files are supposed to be deployed on a
fresh created home directory. If you already have some old rc files, they will
be automatically backed up.  Effected files are:

    .bash_profile .bashrc .cshrc .gitconfig .screenrc .tmux.conf .vimrc

## Installation

Run script `install.sh`. You can `cd` into the directory or not --- things will
go where they should go. During the installation, your git information will be
collected, which includes your full name and email address.

## Multilevel rc

RC files are applied in 3 levels. We have the following reasons to to this:

  - We want handy default configurations that can be easily pulled from remote
    repo;
  - We also need to add site-specific configurations;
  - We don't want site-specific configurations and default configurations go
    same file, which causes problems when `git push/pull`;
  - When configuration file goes big, we want split it into functional parts;
  - We want to easily enable/disable some configurations;
  - And many more reasons.

For example, bash uses the following source file tree:

  - `$HOME/.bashrc -> $UNIX_HOME/dot_files/bashrc`
    - `$UNIX_HOME/bashrc.d/00-basic-functions.sh`
    - `$UNIX_HOME/bashrc.d/03-coreutils-aliases.sh`
    - `$UNIX_HOME/bashrc.d/05-ps1.sh`
    - `$UNIX_HOME/bashrc.d/15-templates.sh`
    - `$UNIX_HOME/bashrc.d/50-site-env.sh`
      - `$HOME/.site_env/bash/*.sh`
    - `$UNIX_HOME/bashrc.d/60-journal.sh`
    - `$UNIX_HOME/bashrc.d/90-ext-tools-aliases.sh`
    - `$UNIX_HOME/bashrc.d/91-fragiles.sh`
    - `$UNIX_HOME/bashrc.d/92-fragile-exec.sh`
    - `$UNIX_HOME/bashrc.d/95-darwin-spec.sh`

All `*.sh` files under `$HOME/.site_env/bash` are considered as site-specific
files and won't be under version control.

Please check `$HOME/.site_env/` out after installation to see what other
configurations supporting multilevel RC.

## Features

### Bash prompt

A fancy command prompt:

 - username@[hostname]. User name comes in green (or red if you are root).

   - Host name can be customized only for bash by adding
     `BASH_PS1_HOSTNAME=your-host-name` in one of your site-specific RC files.

   - When using `connect` as a substitution of `ssh`, OpenSSH session will be
     indicated by displaying [hostname] as a chain.

 - Yellow flashing "&N" indicates the number of background processes, hidden if
   N == 0.

 - Magenta "^N" indicates the shell level ($SHLVL), hidden if N == 0.

 - git-repo-root-dir-name[current-branch] indicates current git context, hidden
   if not in any repo, "(git)" if in `.git` directory.

 - Blue cwd followed by a line break.

 - Physical full pwd (if `$(pwd)` != `$(pwd -P)`) which is very dark.

 - Highlighted "$" (or "#" if you are root).

 - If IFS is not in default, it's value is printed here.

 - YOUR COMMAND goes here.

 - Each pipe level command appears here, fully expanded in absolute path and
   begin-of-execution timestamp, in very dary color.

 - Command status and complete timestamp. Red exception code of each pipe level
   if not all zero, otherwise green.

### Extra shell variables during sourcing ~/.bashrc

 - To override the hostname part in PS1, export a customized
   `BASH_PS1_HOSTNAME` in `~/.site_env/bash/*.sh`.

 - On many platforms (MacOS, Solaris, etc.) GNU coreutils commands are prefixed
   by `g` by default (if installed). To alias them back to regular usage (e.g.,
   `alias ls=gls` etc.), export `GNU_COREUTILS_HOME=</path/to/gnu-coreutils>`.
   If your GNU coreutils have their own prefixes other than `g`, export
   `GNU_COREUTILS_PREFIX=<customized-prefix>` to override.

 - To attach tmux at the end of bash initialization, export `AUTO_ATTACH_TMUX`
   to enable this.

### Tmux appearance enhancement

Session name, hostname, date/time, system load in status bar. Colors adjusted.
Red window tab indicates prefix key activation.

Important remapped keys:

    Prefix key: Ctrl+J Vertical split: Prefix | Horizontal split: Prefix - Show
    pane number: Prefix Space

### Git configurations

Supports git command line aliases:

 - A git log alias `git h`
 
 - `git status -s # aliased to git s`
 
 - Many others please see `dot_files/gitconfig`

Multilevel rc is supported.

### Vim configurations

Key mappings and multilevel rc support.

### Screen configurations

Limited support.

### Csh prompt

Limited support. A slightly engineered prompt and multilevel rc.

