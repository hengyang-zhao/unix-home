for rc in split(globpath("$HOME/.site_env/vim/", "*.vim"), '\n')
    if rc !~ '@\(pre\|post\)\.vim$'
        execute "source" rc
    endif
endfor

