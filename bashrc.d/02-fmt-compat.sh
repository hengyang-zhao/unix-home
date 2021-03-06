__setfmt()
{
    local fmt_ctrl_seq i zero_width_wrapper
    for i; do
        case "$i" in
            ps1_hostname)
                if [ "$UID" -eq 0 ]; then
                    fmt_ctrl_seq+=${MY_FMT_PS1_HOSTNAME_ROOT:-$'\033[31m'}
                else
                    fmt_ctrl_seq+=${MY_FMT_PS1_HOSTNAME:-$'\033[32m'}
                fi
                ;;
            ps1_hostname_highlight)
                fmt_ctrl_seq+=$'\033[4m'
                ;;
            ps1_username)
                if [ "$UID" -eq 0 ]; then
                    fmt_ctrl_seq+=${MY_FMT_PS1_USERNAME_ROOT:-$'\033[31m'}
                else
                    fmt_ctrl_seq+=${MY_FMT_PS1_USERNAME:-$'\033[32m'}
                fi
                ;;
            ps1_hostchain_decor)
                if [ "$UID" -eq 0 ]; then
                    fmt_ctrl_seq+=${MY_FMT_PS1_HOSTCHAIN_DECOR_ROOT:-$'\033[38;5;52m'}
                else
                    fmt_ctrl_seq+=${MY_FMT_PS1_HOSTCHAIN_DECOR:-$'\033[38;5;22m'}
                fi
                ;;
            ps1_ifs)
                fmt_ctrl_seq+=${MY_FMT_PS1_IFS:-$'\033[1m'}
                ;;
            ps1_ifs_value)
                fmt_ctrl_seq+=${MY_FMT_PS1_IFS_VALUE:-$'\033[1;4m'}
                ;;
            ps1_chroot)
                if [ "$UID" -eq 0 ]; then
                    fmt_ctrl_seq+=${MY_FMT_PS1_CHROOT_ROOT:-$'\033[35'}
                else
                    fmt_ctrl_seq+=${MY_FMT_PS1_CHROOT:-$'\033[36'}
                fi
                ;;
            ps1_bg_indicator)
                fmt_ctrl_seq+=${MY_FMT_PS1_BG_INDICATOR:-$'\033[1;5;33m'}
                ;;
            ps1_shlvl_indicator)
                fmt_ctrl_seq+=${MY_FMT_PS1_SHLVL_INDICATOR:-$'\033[35m'}
                ;;
            ps1_screen_indicator)
                fmt_ctrl_seq+=${MY_FMT_PS1_SCREEN_INDICATOR:-$'\033[36m'}
                ;;
            ps1_git_indicator)
                fmt_ctrl_seq+=${MY_FMT_PS1_GIT_INDICATOR:-$'\033[33m'}
                ;;
            ps1_cwd)
                fmt_ctrl_seq+=${MY_FMT_PS1_CWD:-$'\033[1;34m'}
                ;;
            ps1_physical_cwd)
                fmt_ctrl_seq+=${MY_FMT_PS1_PHYSICAL_CWD:-$'\033[90m'}
                ;;
            ps1_dollar_hash)
                fmt_ctrl_seq+=${MY_FMT_PS1_DOLLAR_HASH:-$'\033[1m'}
                ;;
            status_ok)
                fmt_ctrl_seq+=${MY_FMT_STATUS_OK:-$'\033[38;5;22m'}
                ;;
            status_error)
                fmt_ctrl_seq+=${MY_FMT_STATUS_ERROR:-$'\033[38;5;196m'}
                ;;
            underline)
                fmt_ctrl_seq+=$'\033[4m'
                ;;
            horizontal_rule)
                fmt_ctrl_seq+=${MY_FMT_STATUS_HRULE:-$'\033[1m'}
                ;;
            cmd_expansions)
                fmt_ctrl_seq+=${MY_FMT_CMD_EXPANSIONS:-$'\033[90m'}
                ;;
            zero_width)
                zero_width_wrapper=yes
                ;;
        esac
    done

    [ "$zero_width_wrapper" = yes ] && builtin echo -n $'\001'
    builtin echo -n "$fmt_ctrl_seq"
    [ "$zero_width_wrapper" = yes ] && builtin echo -n $'\002'

    return 0
}

__resetfmt()
{
    local resetfmt_ctrl_seq=$'\033[0m'

    [ "$1" = zero_width ] && builtin echo -n $'\001'
    builtin echo -n "$resetfmt_ctrl_seq"
    [ "$1" = zero_width ] && builtin echo -n $'\002'

    return 0
}

