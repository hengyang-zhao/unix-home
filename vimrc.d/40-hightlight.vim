highlight ColorColumn ctermbg=DarkRed
set cursorline

" Change Color when entering Insert Mode
autocmd InsertEnter * highlight CursorLine ctermbg=DarkGray | set colorcolumn=78,80,117,119,120
"
" Revert Color to default when leaving Insert Mode
autocmd InsertLeave * highlight CursorLine ctermbg=None | set colorcolumn=

