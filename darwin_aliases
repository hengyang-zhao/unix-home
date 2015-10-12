__make_darwin_aliases() {

    __alias_gnu_utils [
    __alias_gnu_utils base64
    __alias_gnu_utils basename
    __alias_gnu_utils cat
    __alias_gnu_utils chcon
    __alias_gnu_utils chgrp
    __alias_gnu_utils chmod
    __alias_gnu_utils chown
    __alias_gnu_utils chroot
    __alias_gnu_utils cksum
    __alias_gnu_utils comm
    __alias_gnu_utils cp
    __alias_gnu_utils csplit
    __alias_gnu_utils cut
    __alias_gnu_utils date
    __alias_gnu_utils dd
    __alias_gnu_utils df
    __alias_gnu_utils dir
    __alias_gnu_utils dircolors
    __alias_gnu_utils dirname
    __alias_gnu_utils du
    __alias_gnu_utils echo
    __alias_gnu_utils env
    __alias_gnu_utils expand
    __alias_gnu_utils expr
    __alias_gnu_utils factor
    __alias_gnu_utils false
    __alias_gnu_utils fmt
    __alias_gnu_utils fold
    __alias_gnu_utils groups
    __alias_gnu_utils head
    __alias_gnu_utils hostid
    __alias_gnu_utils id
    __alias_gnu_utils install
    __alias_gnu_utils join
    __alias_gnu_utils kill
    __alias_gnu_utils link
    __alias_gnu_utils ln
    __alias_gnu_utils logname
    __alias_gnu_utils ls --color=auto
    __alias_gnu_utils md5sum
    __alias_gnu_utils mkdir
    __alias_gnu_utils mkfifo
    __alias_gnu_utils mknod
    __alias_gnu_utils mktemp
    __alias_gnu_utils mv
    __alias_gnu_utils nice
    __alias_gnu_utils nl
    __alias_gnu_utils nohup
    __alias_gnu_utils nproc
    __alias_gnu_utils numfmt
    __alias_gnu_utils od
    __alias_gnu_utils paste
    __alias_gnu_utils pathchk
    __alias_gnu_utils pinky
    __alias_gnu_utils pr
    __alias_gnu_utils printenv
    __alias_gnu_utils printf
    __alias_gnu_utils ptx
    __alias_gnu_utils pwd
    __alias_gnu_utils readlink
    __alias_gnu_utils realpath
    __alias_gnu_utils rm
    __alias_gnu_utils rmdir
    __alias_gnu_utils runcon
    __alias_gnu_utils seq
    __alias_gnu_utils sha1sum
    __alias_gnu_utils sha224sum
    __alias_gnu_utils sha256sum
    __alias_gnu_utils sha384sum
    __alias_gnu_utils sha512sum
    __alias_gnu_utils shred
    __alias_gnu_utils shuf
    __alias_gnu_utils sleep
    __alias_gnu_utils sort
    __alias_gnu_utils split
    __alias_gnu_utils stat
    __alias_gnu_utils stdbuf
    __alias_gnu_utils stty
    __alias_gnu_utils sum
    __alias_gnu_utils sync
    __alias_gnu_utils tac
    __alias_gnu_utils tail
    __alias_gnu_utils tee
    __alias_gnu_utils test
    __alias_gnu_utils timeout
    __alias_gnu_utils touch
    __alias_gnu_utils tr
    __alias_gnu_utils true
    __alias_gnu_utils truncate
    __alias_gnu_utils tsort
    __alias_gnu_utils tty
    __alias_gnu_utils uname
    __alias_gnu_utils unexpand
    __alias_gnu_utils uniq
    __alias_gnu_utils unlink
    __alias_gnu_utils uptime
    __alias_gnu_utils users
    __alias_gnu_utils vdir
    __alias_gnu_utils wc
    __alias_gnu_utils who
    __alias_gnu_utils whoami
    __alias_gnu_utils yes
}

__alias_gnu_utils() {
    orig_cmd="$1"
    gnu_prefix=${__DARWIN_GNU_UTILS_PREFIX:-g} # use / if no prefix
    gnu_cmd=$__DARWIN_GNU_UTILS_PATH/$gnu_prefix$orig_cmd
    if [ -x $gnu_cmd ]; then
        if [ -n "$2" ]; then
            gnu_cmd="$gnu_cmd $2"
        fi
        alias $orig_cmd="$gnu_cmd"
    fi
}

if [ -n "$__DARWIN_GNU_UTILS_PATH" ]; then
    __make_darwin_aliases
fi

# vim: set ft=sh:

