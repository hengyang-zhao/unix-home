highlight ColorColumn ctermbg=DarkGray
highlight CursorLine ctermbg=None cterm=None
set cursorline

if !exists("g:colorcolumn_in_edit")
    let g:colorcolumn_in_edit = "78,80,".join(range(100, 120), ",")
endif

function! EnterInsertModeHighlight()
    let &colorcolumn = g:colorcolumn_in_edit
    highlight CursorLineNr cterm=Bold ctermfg=White ctermbg=Magenta
endfunction

function! EnterNormalModeHighlight()
    let &colorcolumn = ""
    highlight CursorLineNr cterm=Bold ctermfg=Yellow ctermbg=DarkGray
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
