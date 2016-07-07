#!/bin/sh

KERNEL=`uname -s`
FORMAT="%-12s%-18s%-10s%-8s%-8s\n"

if [ "$1" = "--header" ]; then
    printf "$FORMAT" "Host" "CPU" "Mem (GB)" "Load" "Screens"
    exit
fi

HOST=$1

case $KERNEL in
    Linux)
        cpuIdMax=`grep processor /proc/cpuinfo | tail -1 | sed 's/.* \([0-9]\+\)$/\1/g'`
        cpuCores=`expr $cpuIdMax + 1`
        cpuFreq=`grep MHz /proc/cpuinfo | tail -1 | sed 's/.* \([0-9]\+\)\..*$/\1/g'`MHz
        memTotalKB=`grep MemTotal /proc/meminfo | sed 's/MemTotal:\s*\([0-9]\+\) kB/\1/g'`
        memTotalGB=`expr $memTotalKB / 1024 / 1024`
        memFreeKB=`grep MemFree /proc/meminfo | sed 's/MemFree:\s*\([0-9]\+\) kB/\1/g'`
        memFreeGB=`expr $memFreeKB / 1024 / 1024`
        loadAvg1Min=`sed 's/^\([0-9\.]\+\) .*$/\1/g' /proc/loadavg`
        screens=`screen -ls | grep -E '[0-9]\.' | wc -l`

        printf "$FORMAT" $HOST "$cpuFreq x $cpuCores" "$memFreeGB/$memTotalGB" $loadAvg1Min $screens
        ;;

    *)
        echo "Ummmm, hi $KERNEL"
        ;;
esac


