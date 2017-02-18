alias helloworld=__create_file_using_template
__create_file_using_template() {

    local ext="$1"
    local tname="$MY_RC_HOME/templates/$ext.template"
    local f fbase

    if ! test -f "$tname"; then

        echo Could not find template file $tname
        echo -n Available choices are:

        for f in $MY_RC_HOME/templates/*.template; do
            fbase=$(basename $f)
            echo -n " ${fbase%.template}"
        done

        echo
        return 1
    fi

    local lineno=$(awk '/Hello, world/ { print NR; exit }' "$tname")

    vim -c "read $tname" +$lineno
}
