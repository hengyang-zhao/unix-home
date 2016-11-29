# my verbose command line prompt

__command_sno=0
__command_errno=0

__bash_ps1_hostname()
{
    if [ -z "$BASH_PS1_HOSTNAME" ]; then
        echo $(hostname -s)
    else
        echo $BASH_PS1_HOSTNAME
    fi
}

__pretty_non_default_ifs() {
    if [[ "${#IFS}" == 3 && "$IFS" == *" "* && "$IFS" == *$'\t'* && "$IFS" == *$'\n'* ]]; then
        return
    fi
    printf $'\033[1m(IFS: \033[4m%q\033[24m)\033[0m ' "$IFS"
}

__pretty_ssh_connection_chain()
{
    local IFS=$' \t\n'
    local items=($SSH_CONNECTION_CHAIN)
    local result=""

    local major_color=$'\033[32m'
    local minor_color=$'\033[2;32m'
    local underscored=$'\033[4m'
    local reset=$'\033[0m'

    result+="$minor_color[$reset"

    local -i i=0
    while [ $i -lt ${#items[@]} ]; do
        case $(expr $i % 3) in
            0)
                [ $(expr $i + 1) = ${#items[@]} ] && result+=$underscored
                result+="$major_color${items[i]}$reset"
                ;;
            1)
                result+="${minor_color}:${items[i]}$reset"
                ;;
            2)
                result+="${minor_color}]${reset}${major_color}->${reset}${minor_color}[${items[i]}:$reset"
                ;;
        esac
        i+=1
    done

    result+="$minor_color]$reset"

    echo $major_color$result$reset
}

PS1='$(

# record status
cwd=$(pwd -P)

# if we are under schroot
if [ -n "$debian_chroot" ]; then
	s="($debian_chroot)"
fi

# if we are root, then print a red name
if [ "$UID" -eq 0 ]; then
    echo -ne "\[\e[1;31m\]\u\[\e[0m\e[2;32m\]@$(__pretty_ssh_connection_chain)\[\e[35m\]$s\[\e[0m\]"
else
    echo -ne "\[\e[36m\]\u\[\e[0m\e[2;32m\]@$(__pretty_ssh_connection_chain)\[\e[36m\]$s\[\e[0m\]"
fi

# if there are background jobs, give the total count
if [ \j -gt 0 ]; then
	echo -ne " \[\e[1;5;33m\]&\j\[\e[0m\]"
fi

# if this is not buttom level shell, give the depth
if [ "$SHLVL" -gt 1 ]; then
	echo -ne " \[\e[35m\]^$((SHLVL-1))\[\e[0m\]"
fi

# if we are in a (GNU) screen, print the session name
if [ -n "$STY" ]; then
    echo -ne " \[\e[36m\]*${STY#*.}*\[\e[0m\]"
fi

# git branch name ( "(.git)" is displayed if we are in the .git)
if type git &>/dev/null; then
	gbr=`git rev-parse --abbrev-ref HEAD 2>/dev/null`
	if [ -n "$gbr" ]; then
		if [ "$gbr" = HEAD ]; then
			gbr=`git rev-parse HEAD 2>/dev/null | head -c8`
		fi
		groot=$(basename ///$(git rev-parse --show-toplevel) 2>/dev/null)

		if [ "${#groot}" -gt 12 ]; then
			groot="${groot: 0:8}\`${groot: -3:3}"
		fi
		if [ "$groot" = / ]; then
			echo -ne " \[\e[33m\](.git)\[\e[0m\]"
		else
			echo -ne " \[\e[33m\]$groot[$gbr]\[\e[0m\]"
		fi
	fi
fi

# of course, print the current working directory
echo -ne " \[\e[1;34m\]\w\[\e[0m\]"

# physical pwd, only shown if different from regular pwd
if [ "$cwd" != "$(pwd)" ]; then
	echo -ne "\n\[\e[90m\](Physical: $cwd)\[\e[0m\]"
fi

# a new line
echo

# finally a highlighted prompt symbol on a new line
echo -ne "\[\e[1m\]\$\[\e[0m\] "

# print IFS if it is non-default
__pretty_non_default_ifs

)' # end of my prompt

__do_before_command() {

    # This assignment must be done first
    __command_errno="${PIPESTATUS[@]}"

    local IFS=$' \t\n'
	if [ "$BASH_COMMAND" = __do_after_command ]; then
		return
	fi
    __command_sno=$(expr $__command_sno + 1)

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
        *)
            cmd_tokens[0]="(?) ${cmd_tokens[0]}"
            ;;
    esac

    echo $'\033[90m'"[$__command_sno] -> ${cmd_tokens[@]} ($(date +"%x %X"))"$'\033[0m'
}

__do_after_command() {
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

		# clear the previous terminal formatting
		echo -n $'\033[0m'

		# if the return value is not OK, tell the errno
		if [ $ret = OK ]; then
			echo -n $'\033[4;2;32m'
			printf "%${COLUMNS}s\n" "$ts [ Status OK ]"
		else
			echo -n $'\033[4;31m'
			printf "%${COLUMNS}s\n" "$ts [ Exception code $errnos ]"
		fi
		echo -n $'\033[0m'
	fi
}
