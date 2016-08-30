#!/bin/sh

UNKNOWN_STR="(unknown)"

IS_LINUX()
{
    test $(uname -s) = Linux
    return $?
}

IS_DARWIN()
{
    test $(uname -s) = Darwin
    return $?
}

if [ "$1" = "--loadavg-1min" ]; then

    if IS_LINUX; then
        uptime | sed 's/^.*load average:\s*\([0-9\.]\+\),.*$/\1/g'
    elif IS_DARWIN; then
        uptime | sed -E 's/^.*load averages: ([[:digit:]\.]+)[[:blank:]]+.*$/\1/g'
    else
        echo $UNKNOWN_STR
    fi
    exit 0

elif [ "$1" = "--loadavg-5min" ]; then

    if IS_LINUX; then
        uptime | sed 's/^.*load average:.*,\s*\([0-9\.]\+\),.*$/\1/g'
    elif IS_DARWIN; then
        uptime | sed -E 's/^.*load averages: [[:digit:]\.]+[[:blank:]]+([[:digit:]\.]+)[[:blank:]]+.*$/\1/g'
    else
        echo $UNKNOWN_STR
    fi
    exit 0

elif [ "$1" = "--loadavg-15min" ]; then

    if IS_LINUX; then
        uptime | sed 's/^.*load average:.*,\s*\([0-9\.]\+\)\s*$/\1/g'
    elif IS_DARWIN; then
        uptime | sed -E 's/^.*load averages:.*[[:blank:]]+([[:digit:]\.]+)$/\1/g'
    else
        echo $UNKNOWN_STR
    fi
    exit 0

elif [ "$1" = "--uptime" ]; then

    if IS_LINUX; then
        uptime -p | sed 's/^up \(.*\)$/\1/g'
    elif IS_DARWIN; then
        uptime | sed -E 's/^.*up[[:blank:]]+(.*),[[:blank:]]+[[:digit:]]+[[:blank:]]+users.*$/\1/g'
    else
        echo $UNKNOWN_STR
    fi
    exit 0

elif [ "$1" = "--cpu-logical-cores" ]; then

    echo $UNKNOWN_STR
    exit 0

elif [ "$1" = "--cpu-freq-mhz" ]; then

    echo $UNKNOWN_STR
    exit 0

elif [ "$1" = "--mem-total" ]; then

    echo $UNKNOWN_STR
    exit 0

elif [ "$1" = "--mem-avail" ]; then

    echo $UNKNOWN_STR
    exit 0

elif [ "$1" = "--swap-total" ]; then

    echo $UNKNOWN_STR
    exit 0

elif [ "$1" = "--swap-avail" ]; then

    echo $UNKNOWN_STR
    exit 0

elif [ "$1" = "--users" ]; then

    if IS_LINUX || IS_DARWIN; then
        echo $(users | wc -w)
    else
        echo $UNKNOWN_STR
    fi
    exit 0

elif [ "$1" = "--users-list" ]; then

    if IS_LINUX || IS_DARWIN; then
        echo $(users)
    else
        echo $UNKNOWN_STR
    fi
    exit 0

elif [ "$1" = "--distinct-users" ]; then

    if IS_LINUX; then
        echo $(users | sed 's/ /\n/g' | sort | uniq | wc -l)
    else
        echo $UNKNOWN_STR
    fi
    exit 0

elif [ "$1" = "--distinct-users-list" ]; then

    if IS_LINUX; then
        echo $(users | sed 's/ /\n/g' | sort | uniq)
    else
        echo $UNKNOWN_STR
    fi

elif [ "$1" = "--tiny-host-name" ]; then

    if IS_LINUX; then
        HOSTNAME=$(hostname -s)
        if [ $(expr length $HOSTNAME) -gt 10 ]; then
            echo $HOSTNAME | sed 's/^\(.\{6\}\).*\(.\{3\}\)$/\1`\2/g'
        else
            echo $HOSTNAME
        fi
    elif IS_DARWIN; then
        HOSTNAME=$(hostname -s)
        if [ $(echo $HOSTNAME | wc -c) -gt 11 ]; then
            echo $HOSTNAME | sed -E 's/^(.{6}).*(.{3})$/\1`\2/g'
        else
            echo $HOSTNAME
        fi
    fi
    exit 0

else
    exit 1
fi
