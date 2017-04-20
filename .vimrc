""" <== START Plugins declarations ==> """

call plug#begin('~/.vim/plugged')
  Plug 'wincent/loupe'
  Plug 'wincent/terminus'
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
  " TODO: use select yajs or vim-es6
  " Plug 'isruslan/vim-es6'
  Plug 'othree/yajs.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'tommcdo/vim-fugitive-blame-ext'
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer --clang-completer', 'on': [] }
  Plug 'kshenoy/vim-signature'
  Plug 'mileszs/ack.vim'
call plug#end()

""" <== END Plugins declarations ==> """

""" <== START NeoMake linters declarations ==> """

let g:neomake_python_enable_makers = ['flake8']
let g:neomake_javascript_enable_makers = ['eslint']
autocmd! BufWritePost * Neomake
autocmd! BufWritePre * normal :%s/\s+$//ge:noh
autocmd! InsertEnter * call InitYCM()
autocmd! VimEnter * IndentGuidesEnable

""" <== END NeoMake linters declarations ==> """

""" <== START Language specific configuration ==> """

autocmd BufNewFile,BufRead *.py call SetPython()
autocmd BufNewFile,BufRead *.js call SetJS()

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

let g:load_ycm_done = 0
function! InitYCM()
  if g:load_ycm_done == 0
    let g:load_ycm_done = 1
    call plug#load('YouCompleteMe')
  endif
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

filetype on
filetype plugin on
let NERDTreeIgnore = [
      \ '*\.pyc',
      \ '__pycache__',
      \ 'celerybeat-schedule',
      \ 'node_modules',
      \ 'yarn.lock',
      \ '.vagga',
      \ '*.egg-info'
  \ ]
set laststatus=2
set timeout timeoutlen=500 ttimeoutlen=100
set wildignore+=*/node_modules/*
set wildignore+=*/__pycache__/*
set wildignore+=*.pyc
set wildignore+=yarn.lock
set wildignore+=*.egg-info
set bo=all

autocmd CompleteDone * pclose
""" <== END Non-specific configuration ==> """

""" <== START Color scheme configuration ==> """

colorscheme tender
hi IndentGuidesEven  ctermbg=236
hi IndentGuidesOdd ctermbg=236


hi StatusLine ctermbg=239 ctermfg=254
hi Visual ctermbg=239
hi LineNr ctermbg=234
hi ExtraWhitespace ctermfg=238

let g:airline_powerline_fonts = 1
set fillchars+=vert:│
set fillchars+=fold:\

hi VertSplit ctermfg=058
hi Comment cterm=italic
""" <== END Color scheme configuration ==> """

" Project-specific configs position at .vimconfig file
" To use it, place the .vimconfig file to root folder of project with config
" manipulations

function! AttachProjectConfig()
  if filereadable(".vimconfig")
    source .vimconfig
  endif
endfunction
autocmd! VimEnter * call AttachProjectConfig()

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif


" Try to suggest own-implemented tag-movement for python

function! TagMoveInit()
  let b:python_tags = {}

endfunction
