" tab formatting
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" configure plugins
set nocompatible
call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['sensible']

Plug 'dense-analysis/ale'
let g:ale_c_gcc_executable = 'gcc-11'
let g:ale_cpp_gcc_executable = 'gcc-11'
let g:ale_echo_msg_error_str = 'ERR'
let g:ale_echo_msg_warning_str = 'WARN'
let g:ale_python_pylint_options = '--rcfile=/Users/LWJ/.pylintrc'
let g:ale_echo_msg_format = '[%severity%] %linter%: %s'
let g:airline#extensions#ale#enabled = 1

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup   = 1
let g:omni_sql_no_default_maps = 1

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
Plug 'tomasiser/vim-code-dark'
let g:airline_theme = 'codedark'

Plug 'farmergreg/vim-lastplace'

call plug#end()

set number
set ruler
set mouse=a
set encoding=utf-8
set termencoding=utf-8
set hlsearch
syntax on

if &t_Co == 8 && $TERM !~# '^Eterm'
    set t_Co=16
endif

if has("autocmd")
    " Use filetype detection and file-based automatic indenting.
    filetype plugin indent on

    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
endif

function SetTabWidth(n)
    exe 'set tabstop='.a:n
    exe 'set shiftwidth='.a:n
    exe 'set softtabstop='.a:n
    set expandtab
endfunction

" line number formatting
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


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

" session
set ssop-=options    " do not store global and local values in a session

" other vim config
set autoread  "auto read files updated from externally
set showmatch "show matching brackets when cursor is over one
set wildmenu  "show menu when using tab to autocomplete and other areas
set clipboard=unnamed          "clipboard sync
set backspace=indent,eol,start "make backspace work
set t_Co=256                   "set colours
set term=xterm-256color        "set colours
set cursorline
set history=1000
set tabpagemax=50
set display+=lastline
set scrolloff=1
set fillchars+=stl:\ ,stlnc:\

"set the color scheme at the end
colorscheme codedark
autocmd vimenter * hi EndOfBuffer ctermbg=none
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
