set number
set ruler
set mouse=a
set encoding=utf-8
set hlsearch
syntax on
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shortmess-=F " give file info messages
set ssop-=options " do not store global and local values in a session
set autoread  "auto read files updated from external sources
set showmatch "show matching brackets when cursor is over one
set wildmenu  "show menu when using tab to autocomplete and other areas
set clipboard=unnamed          "clipboard sync
set backspace=indent,eol,start "make backspace work
set t_Co=256                   "set colour
set secure  " Don't let external configs do scary stuff
set exrc    " Load local vimrc if found
set cursorline
set signcolumn=number
set updatetime=500
set foldmethod=indent
set foldminlines=10
set foldlevelstart=10
set history=1000
set tabpagemax=50
set splitbelow
set splitright
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

" remind if missing plugins are suspected
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \| echom "Warning: Some plugins may not be installed. Run :PlugInstall to install." | endif

" configure vim-plug plugins
set nocompatible

let g:remoteSession = ($SESSION_TYPE =~# '^remote/')

call plug#begin(has('nvim') ? (stdpath('data') . '/plugged') : ('~/.vim/plugged'))

" Syntax highlighting
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['sensible']

" Svelte syntax highlighting
Plug 'evanleck/vim-svelte', {'branch': 'main'}

" code folding
set foldmethod=syntax

" map space to fold
nnoremap <space> za

" map left to 'zc' to fold, map right to 'zo' to unfold
nnoremap <A-M-Left>  zc
nnoremap <A-M-Right> zo

" coc
" Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
let g:coc_start_at_startup = 1

" coc: GoTo code navigation.
nmap <silent> <Leader>dec  <Plug>(coc-declaration)
nmap <silent> <Leader>def  <Plug>(coc-definition)
nmap <silent> <Leader>type <Plug>(coc-type-definition)
nmap <silent> <Leader>impl <Plug>(coc-implementation)
nmap <silent> <Leader>ref  <Plug>(coc-references)
nmap <silent> <Leader>ep   <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>en   <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gk <Plug>(coc-diagnostic-prev)
nmap <silent> gj <Plug>(coc-diagnostic-next)

" coc: Autocomplete on enter.
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" coc: Helper to display documentation.
nmap <silent> <Leader>doc  :call <SID>show_documentation()<CR>
nmap <silent> gh :call <SID>show_documentation()<CR>
nmap <silent> <A-/> :call <SID>show_documentation()<CR>
nmap <silent> ÷ :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" coc: Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" coc: Toggle display hints
nnoremap <Leader>inlay <Esc>:CocCommand document.toggleInlayHint<CR>
nnoremap <Leader>hint  <Esc>:CocCommand document.toggleInlayHint<CR>
nnoremap <Leader>lens  <Esc>:CocCommand document.toggleCodeLens<CR>
nnoremap <C-i> <Esc>:CocCommand document.toggleInlayHint<CR>

" coc: Symbol renaming.
nnoremap <silent> <Leader>rn <Plug>(coc-rename)
nnoremap <silent> <Leader>rf <Plug>(coc-refactor)

" coc: Hide on escape.
nmap <silent> <Esc> :call coc#float#close_all() <CR>

" Huggingface LLM support
Plug 'huggingface/llm.nvim'

" Github Copilot
Plug 'github/copilot.vim'

let g:copilot_filetypes = { 'markdown': v:true, 'ws': v:false }
"let g:copilot_filetypes = { '*': v:false } " disable by default

if system("curl http://localhost:11435/ 2>&1 | grep \"Empty reply from server\"") != ""
  echom "Using ollama-copilot's proxy (local predictions)"
  let g:copilot_proxy = 'http://localhost:11435'
  let g:copilot_proxy_strict_ssl = v:false
endif

" cycle copilot suggestions
inoremap <A-.> <Plug>(copilot-next)
inoremap <A-,> <Plug>(copilot-previous)
inoremap <A-]> <Plug>(copilot-accept-line)
inoremap <A-[> <Plug>(copilot-dismiss)
inoremap <A-\> <Plug>(copilot-suggest)

" mac option key equivalent (mac triggers special characters with alt)
inoremap ≥ <Plug>(copilot-next)
inoremap ≤ <Plug>(copilot-previous)
inoremap ‘ <Plug>(copilot-accept-line)
inoremap “ <Plug>(copilot-dismiss)
inoremap « <Plug>(copilot-suggest)


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
let g:airline#extensions#whitespace#enabled = 0
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
let $FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --follow --hidden --exclude .git --exclude node_modules --exclude build --exclude dist --exclude target --exclude pkg'

" Avoid fzf opening in NERDTree window
nnoremap <silent> <expr> <C-p> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":FZF\<cr>"

" Comment toggling
Plug 'tpope/vim-commentary'

" Xcode building and testing
Plug 'gfontenot/vim-xcode'

" Setup icons
if g:remoteSession
else
  Plug 'ryanoasis/vim-devicons'
endif

" Discord rich presence
Plug 'vimsence/vimsence'
let g:vimsence_small_text = 'NeoVim'
let g:vimsence_small_image = 'neovim'
let g:vimsence_editing_details = 'Editing a file'
let g:vimsence_editing_state = 'Working on a project'
let g:vimsence_file_explorer_text = 'Browsing files'
let g:vimsence_file_explorer_details = 'Looking for files'

" Anvil
"Plug 'git@github.com:wxwern/anvil-lsp.git', {
      \ 'branch': 'experiments',
      \ 'rtp': 'extensions/vim',
      \ 'do': 'cd extensions/vim && npm install && npm run build'
      \ }
Plug '~/Repositories/internal/anvil-lsp', {
      \ 'rtp': 'extensions/vim',
      \ 'do': 'cd extensions/vim && npm install && npm run build'
      \ }

call plug#end()

" OCaml indentation
set rtp^="~/.opam/default/share/ocp-indent/vim

" because syntax highlighting randomly breaks
noremap <Leader>syn <Esc>:syntax sync fromstart<CR>
noremap <C-q>  <Esc>:syntax sync fromstart<CR>
inoremap <C-q> <Esc><Esc>:syntax sync fromstart<CR>

" mappings
" lazy reference of https://vim.fandom.com/wiki/Easier_buffer_switching
" \l       : list buffers
" \b \f \g : go back/forward/last-used buffer
" \tb \tf  : go back/forward tab
" \q \tq   : close buffer/tab
" \1 \2 \3 : go to buffer 1/2/3 etc
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>q :bd<CR>
nnoremap <Leader>tb :tabprevious<CR>
nnoremap <Leader>tn :tabnext<CR>
nnoremap <Leader>tq :tabclose<CR>
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

" Show tabs, spaces and newlines in whitespace files (.ws)
augroup wsfiledetect
  autocmd FileType ws set tabstop=2 shiftwidth=2 softtabstop=0 noexpandtab list listchars=tab:»\ ,trail:·,nbsp:·,eol:¬,lead:·,extends:>,precedes:<

  autocmd FileType ws let g:indentLine_enabled = 0

  autocmd BufRead *.ws setfiletype ws
augroup END

" helper tab width as spaces count (does not auto reindent)
function SetTabWidth(n)
  exe 'set tabstop='.a:n
  exe 'set shiftwidth='.a:n
  exe 'set softtabstop='.a:n
  set expandtab
  echom "Tab width set to ".a:n
endfunction
command! -nargs=1 TabWidth call SetTabWidth(<f-args>)

" alias tab4 and tab2 commands
nnoremap <Leader>tab4 :TabWidth 4<CR>:echom "Tab width set to 4"<CR>
nnoremap <Leader>tab2 :TabWidth 2<CR>:echom "Tab width set to 2"<CR>

" set column line
set colorcolumn=81,121,161,201,241,281,321

" adjust column line for git commit messages
autocmd FileType gitcommit setlocal colorcolumn=51,73

" coc: automatically adjust wincol to avoid covering text
" adjust by multiples of 40 of the max text in the current buffer
" calls coc#config('diagnostic", {'virtualTextWinCol': ??})
function! AdjustCocVirtualTextWinCol(outlier_frac)

  " find the longest line length in the current buffer
  let max_text_width = 0

  let line_lengths = []
  for i in range(1, line('$'))
    let line_length = len(getline(i))
    call add(line_lengths, line_length)
  endfor

  call sort(line_lengths, 'n')
  let index_target = float2nr(ceil(len(line_lengths) * (1 - a:outlier_frac))) - 1
  if index_target < 0
    let index_target = 0
  endif
  let window_width = winwidth('%')
  let true_max_text_width = line_lengths[-1]
  let max_text_width = 0
  if index_target >= 0 && index_target < len(line_lengths)
    let max_text_width = line_lengths[index_target]
  endif

  " set new wincol to next multiple of 40 above max_text_width (min 80)
  let new_wincol = 80
  while new_wincol + 1 < max_text_width
    let new_wincol += 40
  endwhile
  let new_wincol += 1

  " apply new wincol setting
  call coc#config('diagnostic', {'virtualTextWinCol': new_wincol})
endfunction

autocmd BufWinEnter * call AdjustCocVirtualTextWinCol(0.001)
autocmd BufWritePost * call AdjustCocVirtualTextWinCol(0.001)

" reindent entire document, jump back to previous position
nmap <silent> <Tab> gg=G<C-o><C-o>

" set the color scheme at the end
colorscheme codedark

" highlight trailing whitespace
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkred guibg=darkred
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=darkred guibg=darkred

" shortcut to clean trailing whitespace
nnoremap <Leader><space> :%s/\s\+$//g<CR>

" debug syntax highlighting
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" override folded format
highlight Folded ctermfg=white guifg=white guibg=#555555
highlight FoldColumn ctermfg=grey guifg=grey guibg=black

" coc: styling
hi CocFloating guibg=#222222
hi CocFloatingBorder guifg=#888888

" detect ssh and alert

" remove background color from editor
" hi Normal guibg=NONE ctermbg=NONE
" hi EndOfBuffer guibg=NONE ctermbg=NONE
" autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
" autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE


" configure huggingface llm.nvim for offline use
if has("nvim")
  lua require('llm').setup({
        \    backend="ollama",
        \    url = "http://localhost:11434",
        \
        \    model='codellama:code',
        \    fim = {
        \      enabled = true,
        \      prefix = '<PRE> ',
        \      suffix = ' <SUF>',
        \      middle = ' <MID>',
        \    },
        \    accept_keymap = '<F20>',
        \    reject_keymap = '<F21>',
        \    enable_suggestions_on_startup = false,
        \
        \    request_body = {
        \      options = {
        \        temperature = 0.2,
        \        top_p = 0.95,
        \      }
        \    }
        \})

  function UseOllama()
    Copilot disable
    lua (function()
          \   local llm = require('llm.completion')
          \   if not llm.suggestions_enabled then
          \     llm.toggle_suggestion()
          \   end
          \ end)()

    iunmap <Tab>
    lua vim.keymap.set("i", "<Tab>", function ()
          \   local llm = require('llm.completion')
          \   if llm.shown_suggestion ~= nil then
          \     llm.complete()
          \   else
          \     local keys = vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
          \     vim.api.nvim_feedkeys(keys, 'n', false)
          \   end
          \ end,
          \ { noremap = true, silent = true})

    imap <A-]> <F20>
    imap <A-[> <F21>
    imap ‘ <F20>
    imap “ <F21>

    echom "Switched to offline codellama:code model for completions. GitHub Copilot no longer available."

    command! -nargs=0 CopilotOffline echom "Already using offline codellama:code model for completions."
    command! -nargs=0 Copilot echom ":Copilot commands are no longer available in offline mode. Restart vim to enable GitHub Copilot."

  endfunction
  command! -nargs=0 CopilotOffline call UseOllama()
endif
