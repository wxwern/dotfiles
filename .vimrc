call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

Plug 'dense-analysis/ale'
let g:ale_c_gcc_executable = 'gcc-9'
let g:ale_cpp_gcc_executable = 'gcc-9'
let g:ale_echo_msg_error_str = 'ERR'
let g:ale_echo_msg_warning_str = 'WARN'
let g:ale_python_pylint_options = '--rcfile=/Users/LWJ/.pylintrc'
let g:ale_echo_msg_format = '[%severity%] %linter%: %s'
let g:airline#extensions#ale#enabled = 1


call plug#end()


set number
set ruler
set mouse=a
set encoding=utf-8
set termencoding=utf-8
syntax on

if &t_Co == 8 && $TERM !~# '^Eterm'
    set t_Co=16
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Use filetype detection and file-based automatic indenting.
    filetype plugin indent on

    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
endif

" tab formatting
set tabstop=4     " show existing tab with 4 spaces width
set shiftwidth=4  " when indenting with '>', use 4 spaces width
set softtabstop=4 " Sets the number of columns for a TAB.
set expandtab     " expand tBs

" line number formatting
set number relativenumber
"augroup numbertoggle
"  autocmd!
"  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"augroup END


" key remaps
" reindent entire document, jump back to previous position
nmap <Tab> gg=G<C-o><C-o>

" jump to prev/next error
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"Highlight trailing whitespace
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkred guibg=darkred
highlight ExtraWhitespace ctermbg=darkred guibg=darkred 
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/

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

"set the color scheme at the end
colorscheme abstract
