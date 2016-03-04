# my verbose command line prompt
PS1='$(

# save the return value of the last command
t=$?

# record status
ts=$(date +"%b-%d-%Y %T")
cwd=$(pwd -P)

# clear the previous terminal formatting
echo -ne "\[\e[0m\]"

# if the return value is not OK, tell the errno
if [ $t -ne 0 ]; then
    echo -ne "\[\e[4;31m\]"
    if [ \# -gt 1 ]; then
        printf "%${COLUMNS}s\n" "Error occured on $ts [ Code $t ]"
    else
        printf "%${COLUMNS}s\n"
    fi
else
    echo -ne "\[\e[4;90m\]"
    if [ \# -gt 1 ]; then
        printf "%${COLUMNS}s\n" "Finished on $ts [ Status OK ]"
    else
        printf "%${COLUMNS}s\n"
    fi
fi
echo -ne "\[\e[0m\]"

# if we are under schroot
if [ -n "$debian_chroot" ]; then
    s="($debian_chroot)"
fi

# if we are root, then print a red name
if [ $UID -eq 0 ]; then
    echo -ne "\[\e[1;31m\]\u@\h$s\[\e[0m\]"
else
    echo -ne "\[\e[32m\]\u@\h$s\[\e[0m\]"
fi

# if there are background jobs, give the total count
if [ \j -gt 0 ]; then
    echo -ne " \[\e[1;5;33m\]&\j\[\e[0m\]"
fi

# if this is not buttom level shell, give the depth
if [ $SHLVL -gt 1 ]; then
    echo -ne " \[\e[35m\]^$((SHLVL-1))\[\e[0m\]"

    # if we are in a (GNU) screen, tell it
    if [ -n "$STY" ]; then
        echo -ne " \[\e[36m\]*${STY#*.}*\[\e[0m\]"
    fi
fi

# git branch name ( "(.git)" is displayed if we are in the .git)
if which git &>/dev/null; then
    gbr=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
    if [ _"$gbr" != _ ]; then
        if [ "$gbr" = HEAD ]; then
            gbr=`git rev-parse HEAD 2>/dev/null | head -c8`
        fi
        groot=$(basename ///$(git rev-parse --show-toplevel) 2>/dev/null)

        if [ ${#groot} -gt 12 ]; then
            groot="${groot: 0:8}\`${groot: -3:3}"
        fi
        if [ "${groot}" = / ]; then
            echo -ne " \[\e[33m\](.git)\[\e[0m\]"
        else
            echo -ne " \[\e[33m\]$groot[$gbr]\[\e[0m\]"
        fi
    fi
fi

# of course, print the current working directory
echo -ne " \[\e[34m\]\w\[\e[0m\]"

# physical pwd, only shown if different from regular pwd
if [ "$cwd" != "$(pwd)" ]; then
    echo -ne "\n\[\e[2;34m\](Physical: $cwd)\[\e[0m\] "
fi

# finally a highlighted prompt symbol on a new line
echo -ne "\n\[\e[1m\]\$\[\e[0m\] "

)' # end of my prompt
