
" Indentation
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Custom Fx
map <F5> :!python %<CR>

" Highlight area @ column 79+
let &colorcolumn=join(range(80,84),",")
highlight ColorColumn ctermbg=235

