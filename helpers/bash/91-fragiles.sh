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
		echo "** Attempting make in $(realpath $dir)"
		if [ -f $dir/Makefile ] || [ -f $dir/makefile ] || [ -f $dir/GNUmakefile ]; then
			$(which --skip-alias make) -C "$dir" $@
			return $?
		fi

		if [ "$(realpath "$dir")" = / ]; then
			__red_echo "** Cannot find makefile"
			return 1
		fi

		dir+=/..
	done
}
