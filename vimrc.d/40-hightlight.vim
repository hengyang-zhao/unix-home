highlight ColorColumn ctermbg=DarkGray
highlight CursorLine ctermbg=None cterm=None
set cursorline

function! EnterInsertModeHighlight()
    let &colorcolumn="78,80,".join(range(100, 120), ",")
    highlight CursorLineNr ctermfg=White ctermbg=Magenta
endfunction

function! EnterNormalModeHighlight()
    set colorcolumn=
    highlight CursorLineNr ctermfg=Yellow ctermbg=DarkGray
endfunction

autocmd InsertEnter * call EnterInsertModeHighlight()
autocmd InsertLeave * call EnterNormalModeHighlight()

call EnterNormalModeHighlight()

if &term =~ "xterm" || &term =~ "putty"
    set t_ZH=[3m
    set t_ZR=[23m
    highlight Comment cterm=Italic
endif

let g:loaded_matchparen = 0
