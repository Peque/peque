
" Indentation
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Custom Fx
map <F5> :!Rscript %<CR>

" Highlight area @ column 79+
let &colorcolumn=join(range(80,84),",")
highlight ColorColumn ctermbg=235

" Autoremove trailing spaces
autocmd BufWritePre * :%s/\s\+$//e

