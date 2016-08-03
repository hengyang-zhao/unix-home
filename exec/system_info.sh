#!/bin/sh

UNKNOWN_STR="(unknown)"

IS_LINUX()
{
    test $(uname -s) = Linux
    return $?
}

if [ "$1" = "--loadavg-1min" ]; then

    if IS_LINUX; then
        uptime | sed 's/^.*load average:\s*\([0-9\.]\+\),.*$/\1/g'
    fi
    exit 0

elif [ "$1" = "--loadavg-5min" ]; then

    if IS_LINUX; then
        uptime | sed 's/^.*load average:.*,\s*\([0-9\.]\+\),.*$/\1/g'
    fi
    exit 0

elif [ "$1" = "--loadavg-15min" ]; then

    if IS_LINUX; then
        uptime | sed 's/^.*load average:.*,\s*\([0-9\.]\+\)\s*$/\1/g'
    fi
    exit 0

elif [ "$1" = "--uptime" ]; then

    if IS_LINUX; then
        uptime -p | sed 's/^up \(.*\)$/\1/g'
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

    if IS_LINUX; then
        users | wc -w
        exit 0
    fi

elif [ "$1" = "--users-list" ]; then

    if IS_LINUX; then
        users
        exit 0
    fi

elif [ "$1" = "--distinct-users" ]; then

    if IS_LINUX; then
        users | sed 's/ /\n/g' | sort | uniq | wc -l
        exit 0
    fi

elif [ "$1" = "--distinct-users-list" ]; then

    if IS_LINUX; then
        echo $(users | sed 's/ /\n/g' | sort | uniq)
        exit 0
    fi

elif [ "$1" = "--tiny-host-name" ]; then

    if IS_LINUX; then
        HOSTNAME=$(hostname -s)
        if [ $(expr length $HOSTNAME) -gt 10 ]; then
            echo $HOSTNAME | sed 's/^\(.\{6\}\).*\(.\{3\}\)$/\1`\2/g'
        else
            echo $HOSTNAME
        fi
        exit 0
    fi

else
    exit 1
fi
