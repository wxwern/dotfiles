" basic vim config
set number
set ruler
set mouse=a
set encoding=utf-8
set termencoding=utf-8
set hlsearch
syntax on
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set ssop-=options " do not store global and local values in a session
set autoread  "auto read files updated from externally
set showmatch "show matching brackets when cursor is over one
set wildmenu  "show menu when using tab to autocomplete and other areas
set clipboard=unnamed          "clipboard sync
set backspace=indent,eol,start "make backspace work
set t_Co=256                   "set colours
set term=xterm-256color        "set colours
set cursorline
set signcolumn=number
set updatetime=500
set history=1000
set tabpagemax=50
set display+=lastline
set scrolloff=1
set fillchars+=stl:\ ,stlnc:\
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" configure vim-plug plugins
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

" jump to prev/next error (ctrl key and j/k)
nmap <silent> gk <Plug>(ale_previous_wrap)
nmap <silent> gj <Plug>(ale_next_wrap)

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"Plug 'Shougo/deoplete.nvim'
"Plug 'roxma/nvim-yarp'
"Plug 'roxma/vim-hug-neovim-rpc'
"let g:deoplete#enable_at_startup   = 1
"let g:omni_sql_no_default_maps = 1

Plug 'farmergreg/vim-lastplace'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#close_symbol = '×'
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_highlighting_cache = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = '|'
let g:airline_right_sep = ''
let g:airline_right_alt_sep = '|'

Plug 'tomasiser/vim-code-dark'
let g:airline_theme = 'codedark'

Plug 'haya14busa/incsearch.vim'
let g:incsearch#auto_nohlsearch = 1
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

Plug 'preservim/nerdtree' |
      \ Plug 'Xuyuanp/nerdtree-git-plugin' |
      \ Plug 'ryanoasis/vim-devicons'

" Start NERDTree, unless a file or session is specified.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | NERDTreeVCS | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" NERDTree keyboard shortcuts
nnoremap <C-n> :NERDTreeMirror<CR>:NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeMirror<CR>:NERDTreeToggle<CR>
" NERDTree always open in tab
let NERDTreeCustomOpenArgs={'file':{'where': 't', 'reuse': bufname("%") == "" ? 'currenttab': 'all', 'keepopen': 1, 'stay': 0}}

call plug#end()


" line number formatting depending on input modes
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * if !exists('b:NERDTree') || !b:NERDTree.isTabTree() | set relativenumber | endif
  autocmd BufLeave,FocusLost,InsertEnter   * if !exists('b:NERDTree') || !b:NERDTree.isTabTree() | set norelativenumber | endif
augroup END

" Use actual tab chars in Makefiles.
autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab

" helper tab width as spaces count (does not auto reindent)
function SetTabWidth(n)
  exe 'set tabstop='.a:n
  exe 'set shiftwidth='.a:n
  exe 'set softtabstop='.a:n
  set expandtab
endfunction

" reindent entire document, jump back to previous position
nmap <silent> <Tab> gg=G<C-o><C-o>

" Highlight trailing whitespace
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkred guibg=darkred
highlight ExtraWhitespace ctermbg=darkred guibg=darkred
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/

" set the color scheme at the end
colorscheme codedark

" remove bg from colorscheme
autocmd vimenter * hi EndOfBuffer ctermbg=none
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE

