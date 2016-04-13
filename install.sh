#!/bin/bash

PROJ_DIR=`pwd`
ENV_DIR=~/.site_env

echo Creating symlinks for resource files:

cd ~
for f in $PROJ_DIR/dot_*; do
	f=`basename "$f"`
	echo ~/.${f#dot_} '->' $PROJ_DIR/$f
	ln -sf $PROJ_DIR/$f .${f#dot_}
done

mkdir -p $ENV_DIR

echo
echo "Collecting user information for git configuration file:"

git_name=$(git config --get user.name)
if [ -z "$git_name" ]; then
	echo -n "Please enter your full name: "
else
	echo -n "Please enter your full name [$git_name]: "
fi
read name
if [ -z "$name" ]; then
	name="$git_name"
fi

git_email=$(git config --get user.email)
if [ -z "$git_email" ]; then
	echo -n "Please enter your main E-mail address: "
else
	echo -n "Please enter your main E-mail address [$git_email]: "
fi
read email
if [ -z "$email" ]; then
	email="$git_email"
fi

cat > $ENV_DIR/gitconfig << EOF
[user]
	name = $name
	email = $email
EOF

echo "Generated file $ENV_DIR/gitconfig"

echo
echo -n "Please enter the full path of your journal directory [~/journal]:"
read JOURNAL

cat > $ENV_DIR/journal.sh << EOF
export JOURNAL_PATH=${JOURNAL:=~/journal}
EOF

echo "Generated file $ENV_DIR/journal.sh"
echo "Please later clone your journal to $ENV_DIR/journal.sh"

echo
echo "<> <> <>  W E L C O M E   H O M E  <> <> <>"
echo
