#!/bin/bash

MY_RC_HOME=$(builtin cd $(dirname "$0"); builtin pwd)

DOT_FILES_DIR=$MY_RC_HOME/dot_files
SITE_ENV_DIR=$HOME/.site_env

SITE_GIT_DIR=$SITE_ENV_DIR/git
SITE_GITUSER_FILE=$SITE_GIT_DIR/user
SITE_GITCONFIG_FILE=$SITE_GIT_DIR/gitconfig

SITE_VIM_DIR=$SITE_ENV_DIR/vim
SITE_BASH_DIR=$SITE_ENV_DIR/bash
SITE_CSH_DIR=$SITE_ENV_DIR/csh
SITE_TMUX_DIR=$SITE_ENV_DIR/tmux

#
# ~/.site_env/*
#

echo
echo "Creating site specific resource file directories:"

for subdir in $SITE_GIT_DIR $SITE_VIM_DIR $SITE_BASH_DIR $SITE_CSH_DIR $SITE_TMUX_DIR; do
	echo "  new directory $subdir"
	mkdir -p $subdir
done

#
# Git
#

echo
echo "Collecting user information for git configuration file:"

GIT_NAME_OLD=$(git config --get user.name)
if [ -z "$GIT_NAME_OLD" ]; then
	echo -n "  Please enter your full name: "
else
	echo -n "  Please enter your full name [$GIT_NAME_OLD]: "
fi
read GIT_NAME
if [ -z "$GIT_NAME" ]; then
	GIT_NAME="$GIT_NAME_OLD"
fi

GIT_EMAIL_OLD=$(git config --get user.email)
if [ -z "$GIT_EMAIL_OLD" ]; then
	echo -n "  Please enter your main E-mail address: "
else
	echo -n "  Please enter your main E-mail address [$GIT_EMAIL_OLD]: "
fi
read GIT_EMAIL
if [ -z "$GIT_EMAIL" ]; then
	GIT_EMAIL="$GIT_EMAIL_OLD"
fi

cat > $SITE_GITUSER_FILE << EOF
# Automatically generated by unix-home. DO NOT edit.

[user]
	name = $GIT_NAME
	email = $GIT_EMAIL
EOF

echo "  Generated file $SITE_GITUSER_FILE"

touch $SITE_GITCONFIG_FILE
echo "  Generated file $SITE_GITCONFIG_FILE"

#
# TMux
#

echo
touch $SITE_TMUX_DIR/tmux.conf
echo "Generated file $SITE_TMUX_DIR/tmux.conf"

#
# export MY_RC_HOME
#

echo
echo "Registering MY_RC_HOME environment variable:"

cat > $SITE_BASH_DIR/my_rc_home.sh << EOF
# Automatically generated by unix-home. DO NOT edit.

export MY_RC_HOME=$MY_RC_HOME
EOF
echo "  Registered MY_RC_HOME=$MY_RC_HOME in file $SITE_BASH_DIR/my_rc_home.sh"

cat > $SITE_CSH_DIR/my_rc_home.csh << EOF
# Automatically generated by unix-home. DO NOT edit.

setenv MY_RC_HOME $MY_RC_HOME
EOF
echo "  Registered MY_RC_HOME=$MY_RC_HOME in file $SITE_CSH_DIR/my_rc_home.csh"

#
# Symlinks
#

echo
echo "Creating symlinks for resource files:"

for f in $DOT_FILES_DIR/*; do
	f=`basename "$f"`
	echo "  symlink ~/.$f -> $DOT_FILES_DIR/$f"
	(builtin cd; ln -sf $DOT_FILES_DIR/$f .${f#dot_})
done

echo
echo "Installation done."
echo
