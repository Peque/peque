
" Indentation
set shiftwidth=8
set softtabstop=8
set tabstop=8

" Highlight area @ column 79+
let &colorcolumn=join(range(80,84),",")
highlight ColorColumn ctermbg=235

" Autoremove trailing spaces
autocmd BufWritePre * :%s/\s\+$//e

