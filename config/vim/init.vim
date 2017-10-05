" Pathogen infect
execute pathogen#infect()

" jedi-vim
" Do not show docstring window during completion
autocmd FileType python setlocal completeopt-=preview
" Do not start completion after typing a dot
let g:jedi#popup_on_dot = 0
" Use tab for completions
let g:jedi#completions_command = "<C-Space>"
" Defaults
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#rename_command = "<leader>r"

" supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabCrMapping = 1

" Assume .h files are C files and assume Doxygen documentation
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END

" neomake
nnoremap <A-c> :Neomake<CR>
inoremap <A-c> <Esc>:Neomake<CR>

" General settings
syntax on
filetype on
filetype plugin indent on

" clipboard
set clipboard+=unnamed

" By default, ignore case while searching
set ignorecase

" Indentation
set autoindent
set smarttab

" Use background theme
set background=dark

" Cursor line
set cursorline

" Ruler
set ruler

" Italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

" Highlighting
hi cursorline cterm=none ctermfg=none ctermbg=235
hi statusline cterm=none  ctermfg=none ctermbg=none
hi search cterm=bold ctermfg=white ctermbg=DarkGray
hi comment cterm=italic ctermfg=67
hi todo cterm=italic,bold ctermfg=red ctermbg=none
hi fixme cterm=italic,bold ctermfg=white ctermbg=none

" Playing around with windows
map <C-j> <C-W><C-j>
map <C-k> <C-W><C-k>
map <C-l> <C-W><C-l>
map <C-h> <C-W><C-h>
map <C-n> :split<CR>
map <C-m> :vsplit<CR>

" Playing around with tabs
nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-7> :tabmove -1<CR> 
nnoremap <A-8> :tabmove +1<CR> 
nnoremap <A-9> :tabprevious<CR> 
nnoremap <A-0> :tabnext<CR> 
nnoremap <A-e> :tabedit 
inoremap <A-1> <Esc>1gt
inoremap <A-2> <Esc>2gt
inoremap <A-3> <Esc>3gt
inoremap <A-4> <Esc>4gt
inoremap <A-7> <Esc>:tabmove -1<CR>
inoremap <A-8> <Esc>:tabmove +1<CR>
inoremap <A-9> <Esc>:tabprevious<CR>
inoremap <A-0> <Esc>:tabnext<CR>
inoremap <A-e> <Esc>:tabedit 

" [Alt + m] will exit insert mode, clear any command and clear searcf highlight
inoremap <A-m> <Esc>
cnoremap <A-m> <C-c>
nnoremap <silent> <A-m> :nohlsearch<CR> :sign unplace *<CR><Esc>

" [Alt + j/k] will jump faster and centered
nnoremap <A-j> 2jzz
nnoremap <A-k> 2kzz
inoremap <A-j> <Esc>2jzz
inoremap <A-k> <Esc>2kzz

" Next search
nnoremap <A-n> nzz
inoremap <A-n> <Esc>nzz

" Write and quit commands
nnoremap <A-w> :write<CR><Esc>
nnoremap <A-q> :quit<CR><Esc>
inoremap <A-w> <Esc>:write<CR><Esc>
inoremap <A-q> <Esc>

" Make
command Make execute "!make"
map <F9> :Make<CR>
