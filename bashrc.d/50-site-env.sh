# Site scripts

__source_site_rc() {
    local IFS=$' \t\n'
    local rcfile

    if [ -d ~/.site_env/bash ]; then
        for rcfile in ~/.site_env/bash/*.sh ; do
            if [ -r "$rcfile" ]; then
                if [ "${-#*rcfile}" != "$-" ]; then
                    . "$rcfile"
                else
                    . "$rcfile" >/dev/null 2>&1
                fi
            fi
        done
    fi
}
__source_site_rc

