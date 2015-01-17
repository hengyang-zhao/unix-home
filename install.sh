#!/bin/sh

PROJ_DIR=`pwd`

cd ~
for f in $PROJ_DIR/dot_*; do
    f=`basename "$f"`
    echo $PROJ_DIR/$f '->' .${f##dot_}
    ln -sf $PROJ_DIR/$f .${f##dot_}
done

