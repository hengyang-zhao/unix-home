highlight ColorColumn ctermbg=DarkGray
set cursorline

" Change Color when entering Insert Mode
autocmd InsertEnter * let &colorcolumn="78,".join(range(80, 120), ",")
"
" Revert Color to default when leaving Insert Mode
autocmd InsertLeave * set colorcolumn=

