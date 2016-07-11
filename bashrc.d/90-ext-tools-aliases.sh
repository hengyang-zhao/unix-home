__has dict && alias d=__define
__define() {
	if [ 0 -eq $# ]; then
		echo "usage: define <word>" >&2
		return 255
	fi

	declare e=`echo $'\033'[`;
	dict "$@" | \
		sed -e "s/\<\($1\)\>/${e}7;33m\1${e}0m/g" \
		-e "s/^\(From \)\(.*\):$/${e}1m\1${e}4m\2${e}0m${e}1m:${e}0m/g" | \
		less -r
}

__has bc && alias b=__bc_calc
__bc_calc()
{
	if [ $# -eq 0 ]; then
		bc -l
		return
	fi
	if [ "$1" = "-h" ]; then
		echo "obase=16;ibase=16;$2" | bc -lq
		return
	fi
	if [ "$1" = "-h2d" ]; then
		echo "ibase=16;$2" | bc -lq
		return
	fi
	if [ "$1" = "-d2h" ]; then
		echo "obase=16;$2" | bc -lq
		return
	fi
	echo "$1" | bc -lq
}

__has vboxmanage && alias lsvm='__query_vm'
__query_vm()
{
	if ! [ $1 ]; then
		echo $'\033[1m'---- registered guests ----$'\033[0m'
		vboxmanage list vms
		echo $'\033[1m'---- running guests ----$'\033[0m'
		vboxmanage list runningvms
		return 0
	fi

	vboxmanage list vms | grep "\<$1\>" &> /dev/null
	if ! [ 0 = $? ]; then
		echo virtualbox guest "$1" does not exist.
		return -1
	fi

	vboxmanage list runningvms | grep "\<$1\>" &> /dev/null
	if [ 0 = $? ]; then
		echo virtualbox guest "$1" is running.
		return 0
	else
		echo virtualbox guest "$1" is stopped.
		return 1
	fi
}

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