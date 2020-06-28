call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

Plug 'dense-analysis/ale'
let g:ale_c_gcc_executable = 'gcc-9'
let g:ale_cpp_gcc_executable = 'gcc-9'
let g:ale_echo_msg_error_str = 'ERROR'
let g:ale_echo_msg_warning_str = 'WARNING'
let g:ale_python_pylint_options = '--rcfile=/Users/LWJ/.pylintrc'
let g:ale_echo_msg_format = '%linter%: [%severity%] - %s'
let g:airline#extensions#ale#enabled = 1


call plug#end()

set number
set ruler
set mouse=a
set encoding=utf-8
set termencoding=utf-8
syntax on

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Use filetype detection and file-based automatic indenting.
    filetype plugin indent on

    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
endif

" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" Sets the number of columns for a TAB.
set softtabstop=4
" expand
set expandtab


" key remaps
" reindent entire document
map <C-i> gg=G<C-o><C-o>
" jump to prev/next error
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" other vim config
set autoread  "auto read files updated from externally
set showmatch "show matching brackets when cursor is over one
set wildmenu  "show menu when using tab to autocomplete and other areas
set clipboard=unnamed          "clipboard sync
set backspace=indent,eol,start "make backspace work
set t_Co=256                   "set colours
set term=xterm-256color        "set colours
set nocompatible
set history=1000
set tabpagemax=50
set display+=lastline
set scrolloff=1
set fillchars+=stl:\ ,stlnc:\

