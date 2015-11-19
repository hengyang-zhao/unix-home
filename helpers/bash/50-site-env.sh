# Site scripts
if [ -d ~/.site_env ]; then
    for i in ~/.site_env/*.sh ; do
        if [ -r "$i" ]; then
            if [ "${-#*i}" != "$-" ]; then
                . "$i"
            else
                . "$i" >/dev/null 2>&1
            fi
        fi
    done
fi

