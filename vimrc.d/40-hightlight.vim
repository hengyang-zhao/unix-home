highlight ColorColumn ctermbg=DarkGray
highlight CursorLine ctermbg=DarkGray cterm=None
set cursorline

function! EnterInsertModeHighlight()
    let &colorcolumn="78,80,".join(range(100, 120), ",")
    highlight CursorLine ctermbg=None
    highlight CursorLineNr ctermfg=White ctermbg=Magenta
endfunction

function! LeaveInsertModeHighlight()
    set colorcolumn=
    highlight CursorLine ctermbg=DarkGray
    highlight CursorLineNr ctermfg=Yellow ctermbg=None
endfunction

autocmd InsertEnter * call EnterInsertModeHighlight()
autocmd InsertLeave * call LeaveInsertModeHighlight()

