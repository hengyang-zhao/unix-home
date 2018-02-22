__command_sno=0
__command_errno=0

alias __inline_echo='builtin echo -n'

__cursor_xpos() {
    local saved_state xpos dummy
    saved_state=$(stty -g)
    stty -echo
    echo -n $'\033[6n' > /dev/tty; read -s -d ';' dummy; read -s -dR xpos
    echo "$xpos"
    stty $saved_state 2>/dev/null
}

__force_newline() {
    if ! [ "$MY_BASH_ENABLE_EXPLICIT_EOF" = yes ]; then
        return
    fi

    if [ "$(__cursor_xpos)" != 1 ]; then
        __resetfmt
        __setfmt force_newline
        __inline_echo ":EoF:"
        __resetfmt

        if [ "$(__cursor_xpos)" != 1 ]; then
            builtin echo
        fi
    fi
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

    __setfmt ps1_hostchain_decor zero_width
    __inline_echo "@"
    __resetfmt zero_width

    if [ "$MY_BASH_ENABLE_HOSTCHAIN" = no ]; then
        __ps1_hostname
    else
        __ps1_ssh_connection_chain
    fi
    return 0
}

__ps1_username()
{
    __setfmt ps1_username zero_width
    __inline_echo $(whoami)
    __resetfmt zero_width
}

__ps1_hostname()
{
    __setfmt ps1_hostname zero_width
    __inline_echo $(__short_hostname)
    __resetfmt zero_width
    return 0
}

__ps1_non_default_ifs() {
    if [[ "${#IFS}" == 3 && "$IFS" == *" "* && "$IFS" == *$'\t'* && "$IFS" == *$'\n'* ]]; then
        return 1
    fi

    __setfmt ps1_ifs zero_width
    __inline_echo "(IFS="
    __resetfmt zero_width

    __setfmt ps1_ifs_value zero_width
    printf "%q" "$IFS"
    __resetfmt zero_width

    __setfmt ps1_ifs zero_width
    __inline_echo ")"
    __resetfmt zero_width

    return 0
}

__ps1_chroot() {
    if [ -n "$debian_chroot" ]; then
        __setfmt ps1_chroot zero_width
        __inline_echo "($debian_chroot)"
        __resetfmt zero_width
        return 0
    else
        return 1
    fi
}

__ps1_ssh_connection_chain() {
    local IFS=$' \t\n'
    local items=($SSH_CONNECTION_CHAIN)

    local chain="$(__setfmt ps1_hostchain_decor zero_width)[$(__resetfmt zero_width)"

    local -i i=0
    while [ $i -lt ${#items[@]} ]; do
        case "$(expr $i % 3)" in
            0)
                [ $(expr $i + 1) = ${#items[@]} ] && chain+=$(__setfmt ps1_hostname_highlight zero_width)
                chain+="$(__setfmt ps1_hostname zero_width)${items[i]}$(__resetfmt zero_width)"
                ;;
            1)
                chain+="$(__setfmt ps1_hostchain_decor zero_width):${items[i]}$(__resetfmt zero_width)"
                ;;
            2)
                chain+="$(__setfmt ps1_hostchain_decor zero_width)]$(__resetfmt zero_width)"
                chain+="$(__setfmt ps1_hostname zero_width)->$(__resetfmt zero_width)"
                chain+="$(__setfmt ps1_hostchain_decor zero_width)[${items[i]}:$(__resetfmt zero_width)"
                ;;
        esac
        i+=1
    done

    chain+="$(__setfmt ps1_hostchain_decor zero_width)]"

    __inline_echo $(__resetfmt zero_width)$chain$(__resetfmt zero_width)
    return 0
}

__ps1_bg_indicator() {
    local njobs="$1"
    if [ "$njobs" -gt 0 ]; then
        __setfmt ps1_bg_indicator zero_width
        __inline_echo "&$njobs"
        __resetfmt zero_width
        return 0
    fi
    return 1
}

__ps1_shlvl_indicator() {
    if [ "$SHLVL" -gt 1 ]; then
        __setfmt ps1_shlvl_indicator zero_width
        __inline_echo "^$(expr $SHLVL - 1)"
        __resetfmt zero_width
        return 0
    fi
    return 1
}

__ps1_screen_indicator() {
    if [ -n "$STY" ]; then
        __setfmt ps1_screen_indicator zero_width
        __inline_echo "*${STY#*.}*"
        __resetfmt zero_width
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
            __setfmt ps1_git_indicator zero_width
            if [ "$groot" = / ]; then
                __inline_echo "(.git)"
            else
                __inline_echo "$groot[$gbr]"
            fi
            __resetfmt zero_width
            return 0
        fi
    fi
    return 1
}

__ps1_cwd() {
    __setfmt ps1_cwd zero_width
    __inline_echo "$1"
    __resetfmt zero_width
    return 0
}

__ps1_physical_cwd() {
    local physical_cwd="$(pwd -P)"
    if [ "$physical_cwd" != "$(pwd)" ]; then
        __setfmt ps1_physical_cwd zero_width
        __inline_echo "(Physical: $physical_cwd)"
        __resetfmt zero_width
        return 0
    fi
    return 1
}

__ps1_dollar_hash() {
    __setfmt ps1_dollar_hash zero_width
    __inline_echo "$1"
    __resetfmt zero_width
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
__ps1_cwd "\w" && __ps1_newline
__ps1_physical_cwd && __ps1_newline
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

    local sink=${BASH_CMD_EXPANSION_SINK:-&2}
    local proxy_fd=${BASH_CMD_EXPANSION_SINK_PROXY_FD:-99}
    local stat_str="[$__command_sno] -> ${cmd_tokens[@]} ($(date +'%m/%d/%Y %H:%M:%S'))"

    if [ -w "$sink" ]; then
        eval "exec $proxy_fd>>$sink"
    else
        eval "exec $proxy_fd>$sink"
    fi

    __force_newline

    [ -t "$proxy_fd" ] && eval "__setfmt cmd_expansions >&$proxy_fd"
    eval '__inline_echo "$stat_str" '"| tr '[:cntrl:]' '.' >&$proxy_fd"
    [ -t "$proxy_fd" ] && eval "__resetfmt >&$proxy_fd"
    eval "__ps1_newline >&$proxy_fd"

    eval "exec $proxy_fd>&-"
}

__do_after_command() {

    local IFS=$' \t\n'
    local eno ts
    local ret=OK

    __force_newline

    if [ $__command_sno -gt 0 ]; then
        __command_sno=0

        if [ "${MY_BASH_ENABLE_STATUS_LINE}" = no ]; then
            return
        fi

        ts=$(date +"%m/%d/%Y %H:%M:%S")
        for eno in $__command_errno; do
            if [ $eno -ne 0 ]; then
                ret=ERR
                break
            fi
        done

        __resetfmt
        [ "$MY_BASH_THICK_SEPARATOR" = yes ] || __setfmt underline
        if [ $ret = OK ]; then
            __setfmt status_ok
            printf "%${COLUMNS}s\n" "$ts [ Status OK ]"
        else
            __setfmt status_error
            printf "%${COLUMNS}s\n" "$ts [ Exception code $__command_errno ]"
        fi
        __resetfmt

        if [ "$MY_BASH_THICK_SEPARATOR" = yes ]; then
            __setfmt horizontal_rule
            printf "%${COLUMNS}s\n" "" | tr " " "${MY_BASH_THICK_SEPARATOR_CHAR:-~}"
            __resetfmt
        fi
    fi

    # On macOS, the path will be tweaked by /usr/libexec/path_helper.
    # We save the current path every time so subshells can bypass the tweak by
    # reading it back.
    export __macos_path_helper_bypass="$PATH"
}
