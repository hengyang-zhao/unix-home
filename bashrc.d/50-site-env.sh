# Site scripts

__source_site_rc() {
    local IFS=$' \t\n'
    local rcfile

    if [ -d ~/.site_env/bash ]; then
        for rcfile in ~/.site_env/bash/*.sh ; do
            if [ -r "$rcfile" ]; then
                . "$rcfile"
            fi
        done
    fi
}
__source_site_rc

