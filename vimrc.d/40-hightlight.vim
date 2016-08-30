highlight ColorColumn ctermbg=DarkGray
"highlight Comment cterm=italic
set cursorline

" Change Color when entering Insert Mode
autocmd InsertEnter * let &colorcolumn="78,80,".join(range(100, 120), ",") | set nocursorline
"
" Revert Color to default when leaving Insert Mode
autocmd InsertLeave * set colorcolumn= | set cursorline

