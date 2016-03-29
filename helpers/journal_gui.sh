#!/bin/bash

if ! [ -f ~/.site_env/journal.sh ]; then
	exit 1
fi

source ~/.site_env/journal.sh

case "$1" in
	--edit-today)
		gedit $(${JOURNAL_PATH}/get_today.sh)

		notify-send "Today's journal: compiling"
		if make -C ${JOURNAL_PATH} today; then
			notify-send "Today's journal: sucessfully compiled"
		else
			notify-send "Today's journal: compilation failed"
		fi
		;;
	--view)
		exec xdg-open ${JOURNAL_PATH}/main.pdf
		;;
	*)
		true
		;;
esac

# vim: set ft=sh:

