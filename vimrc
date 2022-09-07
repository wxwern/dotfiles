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
set autoread  "auto read files updated from external sources
set showmatch "show matching brackets when cursor is over one
set wildmenu  "show menu when using tab to autocomplete and other areas
set clipboard=unnamed          "clipboard sync
set backspace=indent,eol,start "make backspace work
set t_Co=256                   "set colour
set cursorline
set signcolumn=number
set updatetime=500
set history=1000
set tabpagemax=50
set display+=lastline
set scrolloff=10
set fillchars+=stl:\ ,stlnc:\
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" install vim-plug if needed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" configure vim-plug plugins
set nocompatible
let g:remoteSession = ($STY != "")
call plug#begin(has('nvim') ? (stdpath('data') . '/plugged') : ('~/.vim/plugged'))

" Syntax highlighting
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['sensible']

" Svelte syntax highlighting
Plug 'evanleck/vim-svelte', {'branch': 'main'}

" Setup ALE
Plug 'dense-analysis/ale'
let g:ale_c_gcc_executable = 'gcc-11'
let g:ale_cpp_gcc_executable = 'gcc-11'
let g:ale_echo_msg_error_str = 'ERR'
let g:ale_echo_msg_warning_str = 'WARN'
let g:ale_python_pylint_options = '--rcfile=/Users/LWJ/.pylintrc'
let g:ale_echo_msg_format = '[%severity%] %linter%: %s'
let g:airline#extensions#ale#enabled = 1

" jump to prev/next error (gj gk)
nmap <silent> gk <Plug>(ale_previous_wrap)
nmap <silent> gj <Plug>(ale_next_wrap)

Plug 'neoclide/coc.nvim', {'branch': 'release', 'commit': '0f13f07dea8a06dd93718c0b559fc8dc3dc61fc6' }

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Autocomplete on enter
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Github Copilot
if has('nvim')
  Plug 'github/copilot.vim'
  " cycle copilot suggestions
  inoremap <C-[> <Plug>(copilot-previous)
  inoremap <C-]> <Plug>(copilot-next)
endif

" Return to previous location on reopen.
Plug 'farmergreg/vim-lastplace'
let g:lastplace_ignore = "gitcommit,svn"

" Setup vim airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
if !g:remoteSession
  let g:airline_powerline_fonts = 1
endif

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0
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

Plug 'Yggdroot/indentLine'
let g:indentLine_char_list = ['|', '¦', '┆', '┊', '┊', '┊', '┊', '┊', '┊']
" n for Normal mode
" v for Visual mode
" i for Insert mode
" c for Command line editing, for 'incsearch'
let g:indentLine_concealcursor = ""
let g:indentLine_conceallevel = 2
let g:indentLine_setConceal = 2

Plug 'tomasiser/vim-code-dark'
let g:airline_theme = 'codedark'

" Better search
Plug 'haya14busa/incsearch.vim'
let g:incsearch#auto_nohlsearch = 1
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Fuzzy find
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
map <C-p> :FZF<CR>
let g:fzf_action = {
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

" Avoid fzf opening in NERDTree window
nnoremap <silent> <expr> <C-p> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":FZF\<cr>"

" Comment toggling
Plug 'tpope/vim-commentary'

" Setup NERDTree
if g:remoteSession
  Plug 'preservim/nerdtree' |
        \ Plug 'Xuyuanp/nerdtree-git-plugin'
else
  Plug 'preservim/nerdtree' |
        \ Plug 'Xuyuanp/nerdtree-git-plugin' |
        \ Plug 'ryanoasis/vim-devicons'
endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Discord Rich Presence
Plug 'vimsence/vimsence'

call plug#end()

" because syntax highlighting randomly breaks
noremap <C-q>  <Esc>:syntax sync fromstart<CR>
inoremap <C-q> <Esc><Esc>:syntax sync fromstart<CR>

" mappings
" lazy reference of https://vim.fandom.com/wiki/Easier_buffer_switching
" \l       : list buffers
" \b \f \g : go back/forward/last-used
" \1 \2 \3 : go to buffer 1/2/3 etc
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

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

