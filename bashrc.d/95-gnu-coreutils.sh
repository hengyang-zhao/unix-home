__make_gnu_coretuils_aliases() {

    __alias_gnu_coreutils [
    __alias_gnu_coreutils base64
    __alias_gnu_coreutils basename
    __alias_gnu_coreutils cat
    __alias_gnu_coreutils chcon
    __alias_gnu_coreutils chgrp
    __alias_gnu_coreutils chmod
    __alias_gnu_coreutils chown
    __alias_gnu_coreutils chroot
    __alias_gnu_coreutils cksum
    __alias_gnu_coreutils comm
    __alias_gnu_coreutils cp
    __alias_gnu_coreutils csplit
    __alias_gnu_coreutils cut
    __alias_gnu_coreutils date
    __alias_gnu_coreutils dd
    __alias_gnu_coreutils df
    __alias_gnu_coreutils dir
    __alias_gnu_coreutils dircolors
    __alias_gnu_coreutils dirname
    __alias_gnu_coreutils du
    __alias_gnu_coreutils echo
    __alias_gnu_coreutils egrep
    __alias_gnu_coreutils env
    __alias_gnu_coreutils expand
    __alias_gnu_coreutils expr
    __alias_gnu_coreutils factor
    __alias_gnu_coreutils false
    __alias_gnu_coreutils fgrep
    __alias_gnu_coreutils fmt
    __alias_gnu_coreutils fold
    __alias_gnu_coreutils grep
    __alias_gnu_coreutils groups
    __alias_gnu_coreutils head
    __alias_gnu_coreutils hostid
    __alias_gnu_coreutils id
    __alias_gnu_coreutils install
    __alias_gnu_coreutils join
    __alias_gnu_coreutils kill
    __alias_gnu_coreutils link
    __alias_gnu_coreutils ln
    __alias_gnu_coreutils logname
    __alias_gnu_coreutils ls --color=auto
    __alias_gnu_coreutils md5sum
    __alias_gnu_coreutils mkdir
    __alias_gnu_coreutils mkfifo
    __alias_gnu_coreutils mknod
    __alias_gnu_coreutils mktemp
    __alias_gnu_coreutils mv
    __alias_gnu_coreutils nice
    __alias_gnu_coreutils nl
    __alias_gnu_coreutils nohup
    __alias_gnu_coreutils nproc
    __alias_gnu_coreutils numfmt
    __alias_gnu_coreutils od
    __alias_gnu_coreutils paste
    __alias_gnu_coreutils pathchk
    __alias_gnu_coreutils pinky
    __alias_gnu_coreutils pr
    __alias_gnu_coreutils printenv
    __alias_gnu_coreutils printf
    __alias_gnu_coreutils ptx
    __alias_gnu_coreutils pwd
    __alias_gnu_coreutils readlink
    __alias_gnu_coreutils realpath
    __alias_gnu_coreutils rm
    __alias_gnu_coreutils rmdir
    __alias_gnu_coreutils runcon
    __alias_gnu_coreutils seq
    __alias_gnu_coreutils sha1sum
    __alias_gnu_coreutils sha224sum
    __alias_gnu_coreutils sha256sum
    __alias_gnu_coreutils sha384sum
    __alias_gnu_coreutils sha512sum
    __alias_gnu_coreutils shred
    __alias_gnu_coreutils shuf
    __alias_gnu_coreutils sleep
    __alias_gnu_coreutils sort
    __alias_gnu_coreutils split
    __alias_gnu_coreutils stat
    __alias_gnu_coreutils stdbuf
    __alias_gnu_coreutils stty
    __alias_gnu_coreutils sum
    __alias_gnu_coreutils sync
    __alias_gnu_coreutils tac
    __alias_gnu_coreutils tail
    __alias_gnu_coreutils tee
    __alias_gnu_coreutils test
    __alias_gnu_coreutils timeout
    __alias_gnu_coreutils touch
    __alias_gnu_coreutils tr
    __alias_gnu_coreutils true
    __alias_gnu_coreutils truncate
    __alias_gnu_coreutils tsort
    __alias_gnu_coreutils tty
    __alias_gnu_coreutils uname
    __alias_gnu_coreutils unexpand
    __alias_gnu_coreutils uniq
    __alias_gnu_coreutils unlink
    __alias_gnu_coreutils uptime
    __alias_gnu_coreutils users
    __alias_gnu_coreutils vdir
    __alias_gnu_coreutils wc
    __alias_gnu_coreutils who
    __alias_gnu_coreutils whoami
    __alias_gnu_coreutils yes
}

__alias_gnu_coreutils() {
    orig_cmd="$1"
    gnu_prefix=${GNU_COREUTILS_PREFIX:-g} # use / if no prefix
    gnu_cmd=$GNU_COREUTILS_HOME/$gnu_prefix$orig_cmd
    if [ -x $gnu_cmd ]; then
        if [ -n "$2" ]; then
            gnu_cmd="$gnu_cmd $2"
        fi
        alias $orig_cmd="$gnu_cmd"
    fi
}

if [ -n "$GNU_COREUTILS_HOME" ]; then
    __make_gnu_coretuils_aliases
fi

# vim: set ft=sh:

