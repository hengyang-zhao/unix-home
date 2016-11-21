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
            tmux new -As main
            ;;
        _:)
            tmux ls
            ;;
        *)
            tmux new -As "$1"
            ;;
    esac
}

__ssh()
{
    ssh -t $@ env SSH_CONNECTION_CHAIN="'$SSH_CONNECTION_CHAIN'" bash
}

__ssh_no_tmux()
{
    ssh ssh -t $@ env FORCE_TMUX=no SSH_CONNECTION_CHAIN="'$SSH_CONNECTION_CHAIN'" bash
}

__update_ssh_connection_chain()
{
    if [ -z "$SSH_CONNECTION_CHAIN" ]; then
        SSH_CONNECTION_CHAIN=$(__bash_ps1_hostname)
    else
        local ssh_conn_tokens=($SSH_CONNECTION)
        SSH_CONNECTION_CHAIN="$SSH_CONNECTION_CHAIN ${ssh_conn_tokens[1]} ${ssh_conn_tokens[3]} $(__bash_ps1_hostname)"
    fi
}

__pretty_ssh_connection_chain()
{
    local items=($SSH_CONNECTION_CHAIN)
    local result=""
    local hicolor=$'\033[32m'
    local dimcolor=$'\033[2;32m'
    local rstcolor=$'\033[0m'

    result+="$dimcolor[$rstcolor"

    declare -i i=0
    while [ $i -lt ${#items[@]} ]; do
        case $(expr $i % 3) in
            0)
                result+="$hicolor${items[i]}$rstcolor"
                ;;
            1)
                result+="${dimcolor}:${items[i]}$rstcolor"
                ;;
            2)
                result+="${dimcolor}>-<${items[i]}:$rstcolor"
                ;;
        esac
        i+=1
    done

    result+="$dimcolor]$rstcolor"

    echo $hicolor$result$rstcolor
}
__has ssh && __update_ssh_connection_chain

