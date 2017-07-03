for rc in split(globpath("$HOME/.site_env/vim/", "*.vim"), '\n')
    if rc =~ '@pre\.vim$'
        execute "source" rc
    endif
endfor

