highlight ColorColumn ctermbg=DarkGray
highlight CursorLine ctermbg=None cterm=None
set cursorline

function! EnterInsertModeHighlight()
    let &colorcolumn="78,80,".join(range(100, 120), ",")
    highlight CursorLineNr ctermfg=White ctermbg=Magenta
endfunction

function! LeaveInsertModeHighlight()
    set colorcolumn=
    highlight CursorLineNr ctermfg=None ctermbg=None
endfunction

autocmd InsertEnter * call EnterInsertModeHighlight()
autocmd InsertLeave * call LeaveInsertModeHighlight()

let g:loaded_matchparen = 0
