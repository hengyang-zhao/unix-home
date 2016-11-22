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

__has ssh && alias ssh=__ssh
__ssh()
{
    command ssh -t $@ exec env TMUX_ATTACHED="'$TMUX_ATTACHED'" SSH_CONNECTION_CHAIN="'$SSH_CONNECTION_CHAIN'" bash -l
}

__has ssh && alias ssh-no-tmux=__ssh_no_tmux
__ssh_no_tmux()
{
    command ssh -t $@ exec env FORCE_TMUX=no TMUX_ATTACHED="'$TMUX_ATTACHED'" SSH_CONNECTION_CHAIN="'$SSH_CONNECTION_CHAIN'" bash -l
}

__has ssh && alias ssh-tmux=__ssh_tmux
__ssh_tmux()
{
    command ssh -t $@ exec env FORCE_TMUX=yes TMUX_ATTACHED="'$TMUX_ATTACHED'" SSH_CONNECTION_CHAIN="'$SSH_CONNECTION_CHAIN'" bash -l
}

__update_ssh_connection_chain()
{
    if [ -z "$SSH_CONNECTION_CHAIN" ]; then
        SSH_CONNECTION_CHAIN=$(__bash_ps1_hostname)
    else
        [ -n "$TMUX" ] && return

        local ssh_conn_tokens=($SSH_CONNECTION)
        SSH_CONNECTION_CHAIN="$SSH_CONNECTION_CHAIN ${ssh_conn_tokens[1]} ${ssh_conn_tokens[3]} $(__bash_ps1_hostname)"
    fi
}

__update_tmux_status()
{
    if [ "$TMUX_ATTACHED" = yes ] || [ -n "$TMUX" ]; then
        TMUX_ATTACHED=yes
    fi
}

__do_once && __update_ssh_connection_chain
__do_once && __update_tmux_status

