set nocompatible
set smartindent
set cindent
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
syntax on
set nobackup
set noswapfile
set confirm
set backspace=indent,eol,start
set laststatus=2
set mouse=a
set selection=exclusive
set guifont=Dejavu\ Sans\ Mono:h14
set encoding=utf-8
set completeopt=longest,menu
set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936,utf-16,big5,euc-jp,latin1
set ruler
"set cursorline
"set cursorcolumn

let vim_airline = 1
"let vim_quantum = 1
"let vim_ycm = 1
"let vim_go = 1
"let vim_rust = 1
"let vim_ycmcfg = 1
"let vim_ultisnips = 1
"let vim_tagbar = 1

" vundle plugin
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'

if exists('vim_tagbar')
Plugin 'majutsushi/tagbar'
endif

if exists("vim_rust")
Plugin 'rust-lang/rust.vim'
Plugin 'racer-rust/vim-racer'
endif

if exists("vim_go")
Plugin 'fatih/vim-go'
endif

if exists("vim_ycm")
Plugin 'Valloric/YouCompleteMe'
endif

if exists("vim_airline")
Plugin 'vim-airline/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'
endif

if exists('vim_ultisnips')
Plugin 'SirVer/ultisnips'
endif

if exists('vim_quantum')
Plugin 'gomisc/vim-quantum'
endif

call vundle#end()
filetype plugin indent on

if exists("vim_rust")
let g:rustfmt_autosave = 1
let g:racer_cmd = expand("~/.cargo/bin/racer")
let g:racer_experimental_completer = 1
endif

if exists("vim_go")
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

autocmd FileType go nmap <F2> :GoRename<CR>
endif

if exists("vim_ycmcfg") || exists("vim_ycm")
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
endif

if exists('vim_airline')
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
endif

if exists('vim_ultisnips')
let g:UltiSnipsExpandTrigger = "<C-Right>"
let g:UltiSnipsJumpForwardTrigger = "<Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
endif

if exists('vim_tagbar')
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }
let g:tagbar_width = 26

map <C-K><C-T> :TagbarToggle<CR>
endif

func Hguard()
    let ext = expand('%:e')
    if ext == 'h' || ext == 'hpp'
        let guard = '_' . toupper(substitute(expand('%:t'), '\W', '_', 'g')) . '_'
        call append(0, '#ifndef ' . guard)
        call append(1, '#define ' . guard)
        call append(line('$'), '#endif')
    elseif ext == 'c' || ext == 'cc'
        call append(0, '#include "' . expand('%:t:r') . '.h"')
    endif
endfunc

func BuildSource()
    exec 'w'
    let ext = expand('%:e')
    if ext == 'go'
        exec ':GoBuild'
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

let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
map <C-K><C-N> :NERDTreeToggle<CR>

nmap <F7> :call BuildSource()<CR>
nmap <C-F7> :call CompileFile()<CR>
map <C-K><C-G> <Esc>:call Hguard()<CR>
map <C-B><C-N> <Esc>:bn<CR>
map <C-B><C-A> <Esc>:bad 
map <C-B><C-P> <Esc>:bp<CR>
map <C-B><C-D> <Esc>:bd<CR>
imap <C-K><C-D> ·
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

if &t_Co == 256
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai
endif

if exists('vim_quantum')
set background=dark
let g:quantum_black = 1
let g:quantum_italics = 0
colorscheme quantum
let g:airline_theme='quantum'
endif
