" By default, ignore case while searching
set ignorecase

" Highlight column 80
set colorcolumn=80

" Autowrite changes
set autowrite

" Highlight trailing spaces
highlight ExtraWhitespace ctermbg=lightgreen guibg=lightgreen
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Playing around with tabs
exec "set <A-1>=\e1"
exec "set <A-2>=\e2"
exec "set <A-3>=\e3"
exec "set <A-4>=\e4"
exec "set <A-5>=\e5"
exec "set <A-6>=\e6"
exec "set <A-9>=\e9"
exec "set <A-0>=\e0"
exec "set <A-e>=\ee"
exec "set <A-w>=\ew"
map <A-1> 1gt
map <A-2> 2gt
map <A-3> 3gt
map <A-4> 4gt
map <A-5> 5gt
map <A-6> 6gt
map <A-9> :tabprevious<CR>
map <A-0> :tabnext<CR>
map <A-e> :tabedit 
map <A-w> :tabclose<CR>

" Make
command Make execute "!make"
map <F9> :Make<CR>

" Run
autocmd FileType python
	\ map <F5> :!python %<CR>
autocmd FileType r
	\ map <F5> :!Rscript %<CR>

" Escape
ino jk <esc>
cno jk <c-c>
ino kj <esc>
cno kj <c-c>

