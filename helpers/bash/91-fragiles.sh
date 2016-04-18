__red_stderr()
{
	"$@" 2> >(sed -e 's/\(^.*$\)/'$'\033''[31m\1'$'\033''[0m/g' 1>&2)
}

__verbose_do()
{
	echo -e "\e[1m-> $@\e[0m"
	eval "$@"
	return $?
}
