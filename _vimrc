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
set mouse=a
set selection=exclusive
set guifont=Source\ Code\ Pro:h14
set encoding=utf-8
set completeopt=longest,menu
set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936,utf-16,big5,euc-jp,latin1

if &t_Co == 256
colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1
endif

let vim_go = 1
if exists("vim_go")
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
endif

let vim_youcompleteme = 1
if exists("vim_youcompleteme")
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

nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
endif

let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'


func Hguard()
	let ext = expand('%:e')
	if ext != 'h' && ext != 'hpp'
		return
	endif
	let guard = '_' . toupper(substitute(expand('%:t'), '\W', '_', 'g')) . '_'
	call append(0, '#ifndef ' . guard)
	call append(1, '#define ' . guard)
	call append(line('$'), '#endif /* !' . guard . ' */')
	call append(line('$'), '')
	return 1
endfunc

func BuildSource()
	exec 'w'
	let ext = expand('%:e')
	if ext == 'go'
		exec '!go build'
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
		exec '!gcc -c -Wall -std=c99 ' . file
	elseif ext == 'cpp'
		exec '!gcc -c -Wall -std=c++11 ' . file
	else
		echo 'unknown filetype'
	endif
endfunc

nmap <F7> :call BuildSource()<CR>
nmap <C-B> :call CompileFile()<CR>
map <C-K><C-G> <Esc>:call Hguard()<CR>
map <C-K><C-N> :NERDTreeToggle<CR>

" vundle plugin
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'

if exists("vim_go")
Plugin 'fatih/vim-go'
endif

call vundle#end()
filetype plugin indent on
