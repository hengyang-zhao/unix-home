__command_sno=0
__command_errno=0

__inline_echo() {
    builtin echo -n "$@"
}

__pretty_ssh_connection_chain()
{
    local IFS=$' \t\n'
    local items=($SSH_CONNECTION_CHAIN)

    local chain="$(__setfmt ps1_username)$(whoami)$(__resetfmt)$(__setfmt ps1_hostchain_decor)@$(__resetfmt)"
    local chain="$(__setfmt ps1_hostchain_decor)[$(__resetfmt)"

    local -i i=0
    while [ $i -lt ${#items[@]} ]; do
        case $(expr $i % 3) in
            0)
                [ $(expr $i + 1) = ${#items[@]} ] && chain+=$(__setfmt ps1_hostname_highlight)
                chain+="$(__setfmt ps1_hostname)${items[i]}$(__resetfmt)"
                ;;
            1)
                chain+="$(__setfmt ps1_hostchain_decor):${items[i]}$(__resetfmt)"
                ;;
            2)
                chain+="$(__setfmt ps1_hostchain_decor)]$(__resetfmt)$(__setfmt ps1_hostname)->$(__resetfmt)$(__setfmt ps1_hostchain_decor)[${items[i]}:$(__resetfmt)"
                ;;
        esac
        i+=1
    done

    chain+="$(__setfmt ps1_hostchain_decor)]"

    builtin echo $(__resetfmt)$chain$(__resetfmt)
}

__short_hostname() {
    if [ -z "$BASH_PS1_HOSTNAME" ]; then
        local node_name=$(uname -n)
        __inline_echo ${node_name%%.*}
    else
        __inline_echo $BASH_PS1_HOSTNAME
    fi
}

__ps1_user_at_host() {
    __ps1_username

    __setfmt ps1_hostchain_decor
    __inline_echo "@"
    __resetfmt

    if [ "$MY_BASH_ENABLE_HOST_CHAIN" = no ]; then
        __ps1_hostname
    else
        __ps1_ssh_connection_chain
    fi
    return 0
}

__ps1_username()
{
    __setfmt ps1_username
    __inline_echo $(whoami)
    __resetfmt
}

__ps1_hostname()
{
    __setfmt ps1_hostname
    __inline_echo $(__short_hostname)
    __resetfmt
    return 0
}

__ps1_non_default_ifs() {
    if [[ "${#IFS}" == 3 && "$IFS" == *" "* && "$IFS" == *$'\t'* && "$IFS" == *$'\n'* ]]; then
        return 1
    fi
    printf "$(__setfmt ps1_ifs)(IFS:$(__resetfmt) $(__setfmt ps1_ifs_value)%q$(__resetfmt)$(__setfmt ps1_ifs))$(__resetfmt) " "$IFS"
    return 0
}

__ps1_chroot() {
    if [ -n "$debian_chroot" ]; then
        __setfmt ps1_chroot
        __inline_echo "($debian_chroot)"
        __resetfmt
        return 0
    else
        return 1
    fi
}

__ps1_ssh_connection_chain() {
    if [ "$UID" -eq 0 ]; then
        __inline_echo "$(__pretty_ssh_connection_chain root)"
    else
        __inline_echo "$(__pretty_ssh_connection_chain)"
    fi
    return 0
}

__ps1_bg_indicator() {
    local njobs="$1"
    if [ "$njobs" -gt 0 ]; then
        __setfmt ps1_bg_indicator
        __inline_echo "&$njobs"
        __resetfmt
        return 0
    fi
    return 1
}

__ps1_shlvl_indicator() {
    if [ "$SHLVL" -gt 1 ]; then
        __setfmt ps1_shlvl_indicator
        __inline_echo "$(expr $SHLVL - 1)"
        __resetfmt
        return 0
    fi
    return 1
}

__ps1_screen_indicator() {
    if [ -n "$STY" ]; then
        __setfmt ps1_screen_indicator
        __inline_echo "*${STY#*.}*"
        __resetfmt
        return 0
    fi
    return 1
}

__ps1_git_indicator() {

    if type git &>/dev/null; then
        gbr=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ -n "$gbr" ]; then
            if [ "$gbr" = HEAD ]; then
                gbr=$(git rev-parse HEAD 2>/dev/null | head -c8)
            fi
            groot=$(basename ///$(git rev-parse --show-toplevel) 2>/dev/null)

            if [ "${#groot}" -gt 12 ]; then
                groot="${groot: 0:8}\`${groot: -3:3}"
            fi
            __setfmt ps1_git_indicator
            if [ "$groot" = / ]; then
                __inline_echo "(.git)"
            else
                __inline_echo "$groot[$gbr]"
            fi
            __resetfmt
            return 0
        fi
    fi
    return 1
}

__ps1_cwd() {
    __setfmt ps1_cwd
    __inline_echo "$1"
    __resetfmt
    return 0
}

__ps1_dollar_hash() {
    __setfmt ps1_dollar_hash
    __inline_echo "$1"
    __resetfmt
    return 0
}

__ps1_space() {
    __inline_echo ' '
    return 0
}

__ps1_newline() {
    builtin echo
    return 0
}

PS1='$(
__ps1_user_at_host && __ps1_space
__ps1_chroot && __ps1_space
__ps1_bg_indicator "\j" && __ps1_space
__ps1_shlvl_indicator && __ps1_space
__ps1_screen_indicator && __ps1_space
__ps1_git_indicator && __ps1_space
__ps1_cwd "\w"
__ps1_newline
__ps1_dollar_hash "\$" && __ps1_space
__ps1_non_default_ifs && __ps1_space
)'

__do_before_command() {

    # This assignment must be done first
    __command_errno="${PIPESTATUS[@]}"

    local IFS=$' \t\n'
    if [ "$BASH_COMMAND" = __do_after_command ]; then
        return
    fi
    __command_sno=$(expr $__command_sno + 1)

    if [ "${MY_BASH_ENABLE_CMD_EXPANSION}" = no ]; then
        return
    fi

    read -r -a cmd_tokens <<< "$BASH_COMMAND"
    case $(type -t "${cmd_tokens[0]}") in
        file|alias)
            # even we got alias here, it has already been resolved
            cmd_tokens[0]=$(type -P "${cmd_tokens[0]}")
            ;;
        builtin)
            cmd_tokens[0]="builtin ${cmd_tokens[0]}"
            ;;
        function)
            cmd_tokens[0]="function ${cmd_tokens[0]}"
            ;;
        keyword)
            cmd_tokens[0]="keyword ${cmd_tokens[0]}"
            ;;
        *)
            ;;
    esac

    __setfmt cmd_expansions
    __inline_echo "[$__command_sno] -> ${cmd_tokens[@]} ($(date +"%x %X"))" | tr '[:cntrl:]' '.'
    __resetfmt
    builtin echo
}

__do_after_command() {

    if [ "${MY_BASH_ENABLE_STATUS_LINE}" = no ]; then
        return
    fi

    local errnos=$__command_errno
    local eno
    local ret=OK
    local IFS=$' \t\n'

    for eno in $errnos; do
        if [ $eno -ne 0 ]; then
            ret=ERR
            break
        fi
    done

    local ts=$(date +"%x %X")
    if [ $__command_sno -gt 0 ]; then
        __command_sno=0

        __resetfmt

        # if the return value is not OK, tell the errno
        if [ $ret = OK ]; then
            __setfmt status_ok
            printf "%${COLUMNS}s\n" "$ts [ Status OK ]"
        else
            __setfmt status_error
            printf "%${COLUMNS}s\n" "$ts [ Exception code $errnos ]"
        fi
        __resetfmt
    fi
}
