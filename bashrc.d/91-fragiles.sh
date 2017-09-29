__red_stderr()
{
    "$@" 2> >(sed -e 's/\(^.*$\)/'$'\033''[31m\1'$'\033''[0m/g' 1>&2)
}

__verbose_do()
{
    echo -e "\e[1m=> $@\e[0m"
    eval "$@"
    return $?
}

__highlighted_echo()
{
    echo -e "\e[1m$@\e[0m"
}

__red_echo()
{
    echo -e "\e[31m$@\e[0m"
}

__has make && alias make=__smart_make
__smart_make()
{
    dir=.
    while true; do
        echo "** Attempting make in $(builtin cd "$dir"; pwd)"
        if [ -f $dir/Makefile ] || [ -f $dir/makefile ] || [ -f $dir/GNUmakefile ]; then

            ncores=$(nproc)
            if [ $? = 0 ]; then
                __verbose_do command make -C "$dir" -j$ncores $@
            else
                __verbose_do command make -C "$dir" $@
            fi
            return $?
        fi

        if [ "$(builtin cd "$dir"; pwd)" = / ]; then
            __red_echo "** Cannot find makefile"
            return 1
        fi

        dir+=/..
    done
}

__infinite_bash()
{
    true
    while [ "$?" != 200 ]; do
        clear
        echo
        echo "+============================================================+"
        echo "|                         Bash Trap                          |"
        echo "+------------------------------------------------------------+"
        echo "| ** This session will be RESTARTED on normal exit.          |"
        echo "| ** To escape, use exit code 200.                           |"
        echo "+============================================================+"
        echo
        bash
    done
    return 0
}
alias bashtrap=__infinite_bash

__has hub && alias git=hub

# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
__cd_func()
{
    local x2 the_new_dir adir index
    local -i cnt

    if [[ $1 ==  "--" ]]; then
        dirs -v
        return 0
    fi

    the_new_dir=$1
    [[ -z $1 ]] && the_new_dir=$HOME

    if [[ ${the_new_dir:0:1} == '-' ]]; then
        #
        # Extract dir N from dirs
        index=${the_new_dir:1}
        [[ -z $index ]] && index=1
        adir=$(dirs +$index)
        [[ -z $adir ]] && return 1
        the_new_dir=$adir
    fi

    #
    # '~' has to be substituted by ${HOME}
    [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

    #
    # Now change to the new dir and add to the top of the stack
    pushd "${the_new_dir}" > /dev/null
    [[ $? -ne 0 ]] && return 1
    the_new_dir=$(pwd)

    #
    # Trim down everything beyond 11th entry
    popd -n +11 2>/dev/null 1>/dev/null

    #
    # Remove any other occurence of this dir, skipping the top of the stack
    for ((cnt=1; cnt <= 10; cnt++)); do
        x2=$(dirs +${cnt} 2>/dev/null)
        [[ $? -ne 0 ]] && return 0
        [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
        if [[ "${x2}" == "${the_new_dir}" ]]; then
            popd -n +$cnt 2>/dev/null 1>/dev/null
            cnt=cnt-1
        fi
    done

    return 0
}

alias cd='__verbose_cd'
__verbose_cd() {
    __cd_func "$1"
    local ret=$?
    if [ $ret -eq 0 ]; then
        if [ "$1" != -- ]; then
            ls >&2
        fi
    fi
    return $ret
}
