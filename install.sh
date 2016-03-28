#!/bin/sh

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

echo -n "Please enter your full name: "
read NAME

echo -n "Please enter your main E-mail address: "
read EMAIL

cat > $ENV_DIR/gitconfig << EOF
[user]
    name = $NAME
    email = $EMAIL
EOF

echo "Generated file $ENV_DIR/gitconfig"

echo
echo "<> <> <>  W E L C O M E   H O M E  <> <> <>"
echo
