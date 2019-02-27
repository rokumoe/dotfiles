set nocompatible
set smartindent
set cindent
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set nobackup
set noswapfile
set confirm
set backspace=indent,eol,start
set laststatus=2
set mouse=a
set selection=exclusive
set encoding=utf-8
set completeopt=menu,menuone
set pumheight=16
set wildmenu
set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936,utf-16,big5,euc-jp,latin1
" set ruler
set cursorline
"set cursorcolumn
set number
syntax on

" vundle plugin
" filetype off
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'rust-lang/rust.vim'
Plug 'ervandew/supertab'
Plug 'vim-airline/vim-airline'
Plug 'tyrannicaltoucan/vim-quantum'
call plug#end()
filetype plugin indent on

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif

func BuildSource()
    let ext = expand('%:e')
    if ext == 'go'
        exec ':GoBuild'
    elseif ext == 'rs'
        exec ':Cargo build'
    elseif filereadable('Makefile') || filereadable('makefile') || filereadable('MAKEFILE')
        exec '!make'
    else
        echo 'no buildable target'
    endif
endfunc


func CompileFile()
    exec 'w'
    let ext = expand('%:e')
    let file = expand('%')
    if ext == 'c'
        exec '!gcc -c -Wall -std=c11 -o /tmp/vim.c.o ' . file
    elseif ext == 'cpp'
        exec '!g++ -c -Wall -std=c++11 -o /tmp/vim.cpp.o ' . file
    else
        echo 'unknown filetype'
    endif
endfunc

map <C-K><C-N> :NERDTreeToggle<CR>
nmap <F7> :call BuildSource()<CR>
nmap <C-F7> :call CompileFile()<CR>
map <C-B><C-N> <Esc>:bn<CR>
map <C-B><C-A> <Esc>:bad 
map <C-B><C-P> <Esc>:bp<CR>
map <C-B><C-D> <Esc>:bd<CR>
nmap <F2> :LspRename<CR>
nnoremap <leader>gd :LspDefinition<CR>

let g:rustfmt_autosave = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

let g:SuperTabDefaultCompletionType = "<c-n>"

let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

set background=dark
set termguicolors
let g:quantum_black = 1
let g:quantum_italics = 0
colorscheme quantum
let g:airline_theme='quantum'
