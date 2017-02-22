""" <== START Plugins declarations ==> """

call plug#begin('~/.vim/plugged')
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py', 'on': [] }
  Plug 'http://github.com/airblade/vim-gitgutter'
  Plug 'http://github.com/scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTree'] }
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTree'] }
  Plug 'http://github.com/wavded/vim-stylus', { 'for': 'stylus' }
  Plug 'tpope/vim-surround'
  Plug 'Glench/Vim-Jinja2-Syntax', {'for': ['jinja', 'html'] }
  Plug 'kien/ctrlp.vim'
  Plug 'jacoborus/tender.vim'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'https://github.com/neomake/neomake'
  Plug 'vim-airline/vim-airline'
  Plug 'othree/html5.vim', { 'for': ['html', 'html5'] }
  Plug 'isruslan/vim-es6', { 'for': ['js', 'jsx'] }
  " Plug 'jiangmiao/auto-pairs'
  " Plug 'tpope/vim-fugitive'
  " Plug 'tommcdo/vim-fugitive-blame-ext'
  "   Plug 'idanarye/vim-merginal'
call plug#end()

""" <== END Plugins declarations ==> """

""" <== START NeoMake linters declarations ==> """

let g:neomake_python_enable_makers = ['flake8']
let g:neomake_javascript_enable_makers = ['eslint']
autocmd! BufWritePost * Neomake
autocmd! InsertEnter * call plug#load('YouCompleteMe')

""" <== END NeoMake linters declarations ==> """

""" <== START Language specific configuration ==> """

autocmd BufNewFile,BufRead *.py call SetPython()
autocmd BufNewFile,BufRead *.js call SetJS()
autocmd BufNewFile,BufRead *todo* call SetTodos()
autocmd BufNewFile,BufRead *.md call SetMarkDown()

function! SetMarkDown()
  inoremap № #
  nnoremap Ж :
  nnoremap ж :
  nnoremap :ц :w
  nnoremap :й :q
  setlocal softtabstop=4
  setlocal ts=4 sw=4 et
  setlocal fdm=indent
endfunction

function! SetPython()
  " Python specific declarations
  setlocal softtabstop=4
  setlocal ts=4 sw=4 et
  setlocal fdm=indent
endfunction

function! SetJS()
  " Js specific declarations
  setlocal fdm=marker fmr={,}
endfunction

function! SetTodos()
  "
  " A simple self-written todo manager in vim
  " How to use it:
  "  - press "od" to place date marker
  "  - press "[oO]t" to create new task
  "  - press "[oO]s" to create new subtask
  "  - press ",d" to mark task as done
  "
  setlocal fdm=indent
  setlocal tabstop=2 softtabstop=2 noexpandtab ts=2 sw=0
  setlocal nonumber
  nnoremap ot o<ESC>i<SPACE><SPACE>-<SPACE>[<SPACE>]<SPACE>(#)<ESC>i
  nnoremap Ot O<ESC>i<SPACE><SPACE>-<SPACE>[<SPACE>]<SPACE>(#)<ESC>i
  nnoremap os o<ESC>i<SPACE><SPACE><SPACE><SPACE>-<SPACE>[<SPACE>]<SPACE>
  nnoremap Os O<ESC>i<SPACE><SPACE><SPACE><SPACE>-<SPACE>[<SPACE>]<SPACE>
  nnoremap od :r!date<CR>o<C-o>50i=<ESC><ESC>o<ESC>
  nnoremap oo o
  nnoremap Oo o
  nnoremap ,d ^f[lrx:w<CR>j^f]2l
  nnoremap ^ ^f]2l
  nnoremap j j^f]2l
  nnoremap k k^f]2l
  inoremap <Esc> <Esc>:w<CR>
endfunction

""" <== END Language specific configuration ==> """

""" <== START Non-specific configuration ==> """

set nocompatible
set cindent
set hlsearch
set ic
set incsearch
syntax on
set backspace=indent,eol,start
set wildmenu
set path+=**
set backupcopy=yes
set listchars=tab:▸\ ,trail:·
set list
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
filetype on
filetype plugin on
syntax on
set number
set mouse=a
set et ts=2 sw=2
set laststatus=2
set scrolloff=5
nnoremap ; :
cnoremap <F2> 
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap  :NERDTreeToggle
nnoremap v+ :vertical resize +10
nnoremap v= :vertical resize +10
nnoremap v- :vertical resize -10
nnoremap = :resize +10
nnoremap + :resize +10
nnoremap - :resize -10

filetype on
filetype plugin on
let NERDTreeIgnore = ['*\.pyc', '__pycache__', 'celerybeat-schedule', 'node_modules', 'yarn.lock']
set laststatus=2
set timeout timeoutlen=500 ttimeoutlen=100
set wildignore+=*/node_modules/*
set wildignore+=*/__pycache__/*
set wildignore+=*.pyc
set wildignore+=yarn.lock
set bo=all

autocmd CompleteDone * pclose
""" <== END Non-specific configuration ==> """

""" <== START Color scheme configuration ==> """

colorscheme tender
hi IndentGuidesEven  ctermbg=236
hi IndentGuidesOdd ctermbg=236

autocmd VimEnter * IndentGuidesEnable
autocmd VimEnter * call SetUpWhiteSpaces()

hi StatusLine ctermbg=239 ctermfg=254
hi Visual ctermbg=239
hi LineNr ctermbg=234
hi ExtraWhitespace ctermfg=238

function SetUpWhiteSpaces()
  match ExtraWhitespace /\s\+$/
endfunction

let g:airline_powerline_fonts = 1
set fillchars+=vert:│
set fillchars+=fold:\ 

hi VertSplit ctermfg=058
""" <== END Color scheme configuration ==> """
