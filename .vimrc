set nocompatible

call plug#begin('~/.vim/plugged')
    Plug 'wincent/loupe'
    Plug 'wincent/terminus'
    Plug 'http://github.com/airblade/vim-gitgutter'
    Plug 'http://github.com/scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTree'] }
    Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTree'] }
    Plug 'http://github.com/wavded/vim-stylus', { 'for': 'stylus' }
    Plug 'tpope/vim-surround'
    Plug 'Glench/Vim-Jinja2-Syntax', {'for': ['jinja', 'html'] }
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
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-jedi'
    Plug 'sebastianmarkow/deoplete-rust'
    Plug 'kshenoy/vim-signature'
    Plug 'mileszs/ack.vim'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'vim-scripts/mako.vim'
    Plug 'kana/vim-textobj-user'
    Plug 'michaeljsmith/vim-indent-object'
    Plug 'kana/vim-textobj-line'
    Plug 'glts/vim-textobj-comment'
    Plug 'lucapette/vim-textobj-underscore'
    Plug 'bps/vim-textobj-python'
    Plug 'kana/vim-textobj-entire'
    Plug 'tpope/vim-commentary'
call plug#end()

let mapleader="g"

let g:neomake_python_enable_makers = ['flake8']
let g:neomake_javascript_enable_makers = ['eslint']

if !exists("autocommands_loaded")
  let autocommands_loaded = 1

  autocmd BufWritePost * Neomake
  autocmd BufWritePre * normal :%s/\s+$//ge:noh
  autocmd VimEnter * IndentGuidesEnable

  autocmd BufNewFile,BufRead *.py call SetPython()
  autocmd BufNewFile,BufRead *.js call SetJS()
endif

function! SetPython()
   " Python specific declarations
   setlocal softtabstop=4 ts=4 sw=4 et fdm=indent
endfunction

function! SetJS()
  " Js specific declarations
  setlocal fdm=marker fmr={,}
endfunction

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
setlocal softtabstop=4 ts=4 sw=4 et fdm=indent
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
filetype on
filetype plugin on
syntax on
set number
set mouse=a
set laststatus=2
set scrolloff=5
nnoremap ; :
cnoremap <F2> 
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
set fdm=marker fmr={{{,}}}

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap  :NERDTreeToggle

syntax on

hi IndentGuidesEven  ctermbg=236
hi IndentGuidesOdd ctermbg=236

hi StatusLine ctermbg=239 ctermfg=254
hi Visual ctermbg=239
hi LineNr ctermbg=234
hi ExtraWhitespace ctermfg=238

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

colorscheme tender

let g:airline_powerline_fonts = 1
set fillchars+=vert:│
set fillchars+=fold:\

hi VertSplit ctermfg=058
hi Comment cterm=italic

" Project-specific configs position at .vimconfig file
" To use it, place the .vimconfig file to root folder of project with config
" manipulations

function! AttachProjectConfig()
  if filereadable(".vimconfig")
    source .vimconfig
  endif
endfunction
if !exists("project_config_attach")
  let project_config_attach = 1
  autocmd VimEnter * call AttachProjectConfig()
endif

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

let g:deoplete#enable_at_startup = 1

nmap  :FZF
vmap  :FZF

let g:fzf_layout = { 'down': '~20%' }

nnoremap <ESC> :noh
inoremap <ESC> <ESC>:noh

set relativenumber

set nowrap
