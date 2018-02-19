# Site scripts

# On macOS, the path might be tweaked by /usr/libexec/path_helper.
# If we see a saved PATH we restore it so the tweak can be bypassed.
if [ -n "$__macos_path_helper_bypass" ]; then
    export PATH="$__macos_path_helper_bypass"
fi

__source_site_rc_pre() {
    local IFS=$' \t\n'
    local rcfile

    if [ -d $HOME/.site_env/bash ]; then
        for rcfile in $HOME/.site_env/bash/*.sh ; do
            if [ -r "$rcfile" ] && [ "${rcfile##*@}" = "pre.sh" ]; then
                . "$rcfile"
            fi
        done
    fi
}
__source_site_rc_pre

