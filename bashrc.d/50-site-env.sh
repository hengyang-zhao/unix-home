# Site scripts

function __source_site_rc() {
    if [ -d ~/.site_env/bash ]; then
        local IFS=$' \t\n'
        for i in ~/.site_env/bash/*.sh ; do
            if [ -r "$i" ]; then
                if [ "${-#*i}" != "$-" ]; then
                    . "$i"
                else
                    . "$i" >/dev/null 2>&1
                fi
            fi
        done
    fi
}

__source_site_rc

