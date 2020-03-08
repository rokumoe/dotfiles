"let uselang = 'go'
let uselang = 'rs'
"let uselang = 'none'

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
set ruler
"set cursorline
"set cursorcolumn
set number
syntax on

" vundle plugin
" filetype off
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'tyrannicaltoucan/vim-quantum'

if uselang == 'rs'
Plug 'rust-lang/rust.vim'

Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

"Plug 'ervandew/supertab'

elseif uselang == 'go'

Plug 'fatih/vim-go'
Plug 'Valloric/YouCompleteMe'

endif
call plug#end()
filetype plugin indent on

func BuildSource()
    let ext = expand('%:e')
    if ext == 'go'
        exec ':GoBuild'
    elseif ext == 'rs'
        exec '!cargo build'
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

if uselang == 'rs'

nmap <F2> :LspRename<CR>
nnoremap <leader>gd :LspDefinition<CR>

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

let g:lsp_diagnostics_enabled = 0
let g:lsp_highlights_enabled = 0

"if executable('rls')
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'rls',
"        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
"        \ 'whitelist': ['rust'],
"        \ })
"endif

au User lsp_setup call lsp#register_server({
    \ 'name': 'rust-analyzer',
    \ 'cmd': {server_info->['rust-analyzer-linux']},
    \ 'whitelist': ['rust'],
    \ })

nnoremap <S-F12> :Cargo run<CR>

let g:rustfmt_autosave = 1

elseif uselang == 'go'

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_template_use_pkg = 1
let g:go_fmt_command = "goimports"
let g:go_bin_path = expand("~/src/go/bin")
let g:go_fmt_fail_silently = 1
let g:go_get_update = 0

let g:ycm_global_ycm_extra_conf = '~/.vim/ycm/.ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_cache_omnifunc = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_key_invoke_completion = '<C-\>'
let g:ycm_semantic_triggers = {}
let g:ycm_semantic_triggers.c = ['->', '.', ' ', '(', '[', '&']
let g:ycm_semantic_triggers.cpp = ['->', '.', '(', '[', '&']

nnoremap <leader>jd :YcmCompleter GoTo<CR>

nnoremap <F2> :GoRename<CR>
imap <C-K><C-D> ·

endif

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

set background=dark
set termguicolors
let g:quantum_black = 1
let g:quantum_italics = 0
colorscheme quantum
let g:airline_theme='quantum'
