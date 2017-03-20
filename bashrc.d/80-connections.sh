__has screen && alias c=__connect_screen
__connect_screen()
{
    if [ -n "$STY" ]; then
        echo '*** Nested screen is forbidden here ***'
        return
    fi

    case "_$1" in
        _)
            screen -q -x main || screen -S main
            ;;
        _:)
            screen -ls
            ;;
        _::)
            screen -q -ls
            errno=$?

            if [ $errno -le 10 ]; then
                echo '*** No available screens to attach. ***'
                return
            fi

              scrno=`screen -ls | sed -e '2q;d' | sed 's/^\s*\([0-9]\+\).*$/\1/g'`
            screen -x $scrno
            ;;
        *)
            screen -q -x "$1" || screen -S "$1"
            ;;
    esac
}

__has tmux && alias t=__connect_tmux
__connect_tmux()
{
    case "_$1" in
        _)
            [ "$TMUX_ATTACHED" != yes ] && tmux new -As main
            ;;
        _:)
            tmux ls
            ;;
        *)
            [ "$TMUX_ATTACHED" != yes ] && tmux new -As "$1"
            ;;
    esac
}

__has ssh && alias connect=__connect_ssh
__connect_ssh()
{
    command ssh -t $@ exec env TMUX_ATTACHED="'$TMUX_ATTACHED'" SSH_CONNECTION_CHAIN="'$SSH_CONNECTION_CHAIN'" bash --login
}

__has ssh && alias connect-no-tmux=__connect_ssh_no_tmux
__connect_ssh_no_tmux()
{
    command ssh -t $@ exec env FORCE_TMUX=no TMUX_ATTACHED="'$TMUX_ATTACHED'" SSH_CONNECTION_CHAIN="'$SSH_CONNECTION_CHAIN'" bash --login
}

__has ssh && alias connect-tmux=__connect_ssh_tmux
__connect_ssh_tmux()
{
    command ssh -t $@ exec env FORCE_TMUX=yes TMUX_ATTACHED="'$TMUX_ATTACHED'" SSH_CONNECTION_CHAIN="'$SSH_CONNECTION_CHAIN'" bash --login
}

__update_ssh_connection_chain()
{
    if [ "$__ssh_connection_chain_updated" = yes ]; then
        return
    fi

    local IFS=$' \t\n'
    local ps1_hostname=$(__short_hostname)

    if [ -n "$TMUX" ] || [ -z "$SSH_CONNECTION_CHAIN" ]; then
        SSH_CONNECTION_CHAIN=$ps1_hostname
    else

        local ssh_conn_tokens=($SSH_CONNECTION)
        local ssh_conn_chain_tokens=($SSH_CONNECTION_CHAIN)
        local ntok=${#ssh_conn_chain_tokens[@]}

        if [ "$ntok" -gt 3 ] && [ "${ssh_conn_chain_tokens[ntok-1]}" = "$ps1_hostname" ] \
                && [ "${ssh_conn_chain_tokens[ntok-2]}" = "${ssh_conn_tokens[3]}" ] \
                && [ "${ssh_conn_chain_tokens[ntok-3]}" = "${ssh_conn_tokens[1]}" ]; then
            return
        fi

        SSH_CONNECTION_CHAIN="$SSH_CONNECTION_CHAIN ${ssh_conn_tokens[1]} ${ssh_conn_tokens[3]} $ps1_hostname"
    fi

    __ssh_connection_chain_updated=yes
}

__update_tmux_status()
{
    if [ "$TMUX_ATTACHED" = yes ] || [ -n "$TMUX" ]; then
        TMUX_ATTACHED=yes
    fi
}

__update_ssh_connection_chain
__update_tmux_status

