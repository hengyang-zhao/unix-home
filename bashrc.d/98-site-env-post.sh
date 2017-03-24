# Site scripts

__source_site_rc() {
    local IFS=$' \t\n'
    local rcfile

    if [ -d $HOME/.site_env/bash ]; then
        for rcfile in $HOME/.site_env/bash/*.sh ; do
            if [ -r "$rcfile" ] && [ "${rcfile##*@}" = "post.sh" ]; then
                . "$rcfile"
            fi
        done
    fi
}
__source_site_rc

__do_once && export PATH=$HOME/.site_env/exec:$PATH

