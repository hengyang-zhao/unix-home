# Site scripts

__source_site_rc_post() {
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
__source_site_rc_post

# On macOS, the path will be tweaked by /usr/libexec/path_helper.
# We save the current path so subshells can bypass the tweak by reading it back.
export __macos_path_helper_bypass="$PATH"
