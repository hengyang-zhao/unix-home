__journal_exists() {
	[ -d "$JOURNAL_PATH" ]
}

__journal_exists && alias E=__journal_edit_today
__journal_edit_today() {
	vim $($JOURNAL_PATH/get_today.sh)
}

__journal_exists && __has latex && alias T=__journal_view_today
__journal_view_today() {
	make -iC $JOURNAL_PATH today && o $JOURNAL_PATH/main.pdf
}

__journal_exists && __has latex && alias W=__journal_view_whole
__journal_view_whole() {
	make -C $JOURNAL_PATH whole && o $JOURNAL_PATH/main.pdf
}

__journal_exists && alias U=__journal_commit
__journal_commit() {
	echo "Automatically add and commit journal repo $JOURNAL_PATH:"
	echo "The current status is:"
	echo
	(builtin cd $JOURNAL_PATH && git s)
	echo
	echo "Does it look okay to commit all files under entries/ ? [yes|NO]"
	read ans

	while [ "${ans,,}" != yes ] && [ "${ans,,}" != no ]; do
		if [ -z "$ans" ]; then
			ans=NO
			continue
		fi
		echo "Please answer YES or NO (default):"
		read ans
	done

	if [ "${ans,,}" = no ]; then
		echo "Cancelled by user"
		return 1
	fi

	TMPBRANCH=_auto_

	(builtin cd $JOURNAL_PATH && \
		__verbose_do git add entries && \
		__verbose_do git branch $TMPBRANCH && \
		__verbose_do git checkout $TMPBRANCH && \
		__verbose_do git commit -m \'"Automatic entries update"$'\n\n'"From $(hostname -f)"\' && \
		__verbose_do git checkout master && \
		__verbose_do git pull origin master && \
		__verbose_do git merge $TMPBRANCH && \
		__verbose_do git branch -d $TMPBRANCH && \
		__verbose_do git push origin master)

	if [ $? -eq 0 ]; then
		echo Automatic journal update complete
	else
		echo Error occured. Please roll back manually.
	fi
}
