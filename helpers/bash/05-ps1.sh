# my verbose command line prompt

declare -i __command_sno_last_seen=0
declare -i __command_sno=0
declare __allow_hrule=no

PS1='$(

# save the return value of the last commands
eno=${PIPESTATUS[@]}
sok=OK
for i in $eno; do
	if [ $i -ne 0 ]; then
		sok=ERR
		break
	fi
done

# record status
ts=$(date +"%b-%d-%Y %T")
cwd=$(pwd -P)

# clear the previous terminal formatting
echo -ne "\[\e[0m\]"

if [ $__allow_hrule = yes ]; then

	# if the return value is not OK, tell the errno
	if [ $sok = OK ]; then
		echo -ne "\[\e[4;2;32m\]"
		printf "%${COLUMNS}s\n" "Finished on $ts [ Status OK ]"
	else
		echo -ne "\[\e[4;31m\]"
		printf "%${COLUMNS}s\n" "Error occured on $ts [ Code $eno ]"
	fi
	echo -ne "\[\e[0m\]"
fi

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
	echo -ne "\n\[\e[2;34m\](Physical: $cwd)\[\e[0m\]"
fi

# finally a highlighted prompt symbol on a new line
echo -ne "\n\[\e[1m\]\$\[\e[0m\] "

)' # end of my prompt

__do_before_command() {
	if [ "$BASH_COMMAND" = __do_after_command ]; then
		return
	fi
	local parts
	__command_executed=$BASH_COMMAND
	read -r -a cmd_tokens <<< $__command_executed
	enable | grep -q "\<${cmd_tokens[0]}\>"
	if [ $? -eq 0 ]; then
		cmd_tokens[0]="builtin(${cmd_tokens[0]})"
	else
		cmd_head=$(which --skip-alias --skip-functions ${cmd_tokens[0]} 2>/dev/null)
		if [ $? -eq 0 ]; then
			cmd_tokens[0]="$cmd_head"
		fi
	fi
	echo -e "\e[90m-> ${cmd_tokens[@]}\e[0m" >&2
	__command_sno+=1
}

__do_after_command() {
	if [ $__command_sno_last_seen -lt $__command_sno ]; then
		__command_sno_last_seen=$__command_sno
		__allow_hrule=yes
	else
		__allow_hrule=no
	fi
}
