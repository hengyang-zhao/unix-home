alias helloworld=__create_file_using_template
__create_file_using_template() {

    test $# = 0 && return 1

    local fname="$1"

    test -e "$fname" && return 2

    local ext="${1##*.}"
    local tname="$HOME/unix-home/helpers/templates/$ext.template"

    test -e "$tname" || return 3

    local lineno=$(awk '/Hello, world/ { print NR; exit }' "$tname")

    cp "$tname" "$fname"
    vim +$lineno "$fname"
}
