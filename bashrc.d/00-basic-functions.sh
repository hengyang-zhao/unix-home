__has() {
    type "$1" &>/dev/null
    return $?
}

__do_once_func() {

    if [ $# -gt 1 ]; then
        echo "WARN: using __do_once with more than one parameters"
        echo "WARN: parameters: $@"
    fi

    local key="$1"
    local k

    for k in $__DID_ONCE; do
        if [ "$k" = "$key" ]; then
            return 1
        fi
    done

    __DID_ONCE="$__DID_ONCE $key"
    export __DID_ONCE

    return 0
}
alias __do_once='__do_once_func $BASH_SOURCE:$LINENO'

