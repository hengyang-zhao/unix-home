alias helloworld=__create_file_using_template
__create_file_using_template() {

    local ext="$1"
    local tname="$MY_RC_HOME/templates/$ext.template"

    test -f "$tname" || return 1

    local lineno=$(awk '/Hello, world/ { print NR; exit }' "$tname")

    vim -c "read $tname" +$lineno
}
