__has() {
	type "$1" &>/dev/null
	return $?
}

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
__cd_func()
{
	local x2 the_new_dir adir index
	local -i cnt

	if [[ $1 ==  "--" ]]; then
		dirs -v
		return 0
	fi

	the_new_dir=$1
	[[ -z $1 ]] && the_new_dir=$HOME

	if [[ ${the_new_dir:0:1} == '-' ]]; then
		#
		# Extract dir N from dirs
		index=${the_new_dir:1}
		[[ -z $index ]] && index=1
		adir=$(dirs +$index)
		[[ -z $adir ]] && return 1
		the_new_dir=$adir
	fi

	#
	# '~' has to be substituted by ${HOME}
	[[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

	#
	# Now change to the new dir and add to the top of the stack
	pushd "${the_new_dir}" > /dev/null
	[[ $? -ne 0 ]] && return 1
	the_new_dir=$(pwd)

	#
	# Trim down everything beyond 11th entry
	popd -n +11 2>/dev/null 1>/dev/null

	#
	# Remove any other occurence of this dir, skipping the top of the stack
	for ((cnt=1; cnt <= 10; cnt++)); do
		x2=$(dirs +${cnt} 2>/dev/null)
		[[ $? -ne 0 ]] && return 0
		[[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
		if [[ "${x2}" == "${the_new_dir}" ]]; then
			popd -n +$cnt 2>/dev/null 1>/dev/null
			cnt=cnt-1
		fi
	done

	return 0
}

alias cd='__verbose_cd'
__verbose_cd() {
	__cd_func "$1"
	local ret=$?
	if [ $ret -eq 0 ]; then
		if [ "$1" != -- ]; then
			ls >&2
		fi
	fi
	return $ret
}

alias __append='__update_export --append'
alias __prepend='__update_export --prepend'
__update_export()
{
    local IFS=$' \t\n'
    local action
	case "$1" in
		--append)
			action=append
			shift
			;;
		--prepend)
			action=prepend
			shift
			;;
		--)
			action=append
			shift
			;;
		-*)
			echo Unsupported action: $1
			return
			;;
		*)
			action=append
			;;
	esac

	[ -z "$1" ] && return 1
	[ -z "$2" ] && return 2

	local varname="$1"
	local newvalue="$2"

	local varvalue="`eval echo '$'$varname`"

	[ "$varvalue" = '$' ] && varvalue=

    local i
	for i in `echo $varvalue | sed -e 's/:/ /g'`; do
		[ "$newvalue" = "$i" ] && return 3
	done

	if [ -z "$varvalue" ]; then
		export $varname="$newvalue"
	else
		if [ $action = append ]; then
			export $varname="$varvalue":"$newvalue"
		elif [ $action = prepend ]; then
			export $varname="$newvalue":"$varvalue"
		else
			echo __update_export is kidding you
		fi
	fi
}
