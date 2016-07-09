for rc in split(globpath("$HOME/.site_env/vim/", "*.vim"), '\n')
    execute "source" rc
endfor

