set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Plugins {{{

call plug#begin('~/.vim/plugged')
    Plug 'wincent/loupe'
    Plug 'wincent/terminus'
    Plug 'http://github.com/airblade/vim-gitgutter'
    Plug 'http://github.com/scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTree'] }
    " Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTree'] }
    Plug 'http://github.com/wavded/vim-stylus', { 'for': 'stylus' }
    Plug 'tpope/vim-surround'
    Plug 'Glench/Vim-Jinja2-Syntax', {'for': ['jinja', 'html'] }
    Plug 'jacoborus/tender.vim'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'w0rp/ale'
    " Plug 'vim-airline/vim-airline'
    Plug 'othree/html5.vim', { 'for': ['html', 'html5'] }
    " TODO: use select yajs or vim-es6
    " Plug 'isruslan/vim-es6'
    Plug 'othree/yajs.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'tommcdo/vim-fugitive-blame-ext'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-jedi', {'for': ['python']}
    Plug 'sebastianmarkow/deoplete-rust', {'for': ['rust']}
    Plug 'kshenoy/vim-signature'
    " Plug 'mileszs/ack.vim'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'vim-scripts/mako.vim'
    Plug 'kana/vim-textobj-user'
    Plug 'michaeljsmith/vim-indent-object'
    Plug 'kana/vim-textobj-line'
    Plug 'glts/vim-textobj-comment'
    Plug 'lucapette/vim-textobj-underscore'
    Plug 'bps/vim-textobj-python', { 'for': ['python', 'rst', 'md'] }
    Plug 'kana/vim-textobj-entire'
    Plug 'tpope/vim-commentary'
    Plug 'jaxbot/semantic-highlight.vim'
    Plug 'tpope/vim-eunuch'
    Plug 'artur-shaik/vim-javacomplete2'
    Plug 'hsanson/vim-android', {'for': ['java'. 'groovy'. 'scala']}
    Plug 'tfnico/vim-gradle', {'for': ['java'. 'groovy'. 'scala']}
    Plug 'zchee/deoplete-clang', { 'for': ['c', 'cpp', 'c++'] }
    Plug 'kchmck/vim-coffee-script'
call plug#end()

" }}}

" Autocommands {{{

if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    autocmd BufWritePre * normal :%s/\s+$//ge:noh
    autocmd VimEnter * IndentGuidesEnable

    autocmd Syntax python call SetPython()
    autocmd Syntax lua call SetLua()
    autocmd Syntax javascript call SetJS()
    autocmd BufRead *.mako set syntax=mako

    autocmd CompleteDone * pclose
endif

" }}}

" Specific setups {{{

function! SetLua()
    setlocal softtabstop=2 ts=2 sw=2 et
endfunction

function! SetPython()
   setlocal softtabstop=4 ts=4 sw=4 et
endfunction

function! SetJS()
  " Js specific declarations
  setlocal softtabstop=2 tw=2 sw=2 et fdm=marker fmr={,}
endfunction

" }}}

" Global setup {{{

set tw=79
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
setlocal softtabstop=4 ts=4 sw=4 et
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
set fdm=marker fmr={{{,}}}
set laststatus=2
set timeout timeoutlen=500 ttimeoutlen=200
set softtabstop=4 ts=4 sw=4 et
filetype on
filetype plugin on

set fillchars+=vert:│
set fillchars+=fold:\

set bo=all
" set relativenumber
set nowrap

let NERDTreeIgnore = [
      \ '*\.pyc',
      \ '__pycache__',
      \ 'celerybeat-schedule',
      \ 'node_modules',
      \ 'yarn.lock',
      \ '.vagga',
      \ '*.egg-info',
      \ 'build/'
  \ ]
set wildignore+=*/node_modules/*
set wildignore+=*/__pycache__/*
set wildignore+=*.pyc
set wildignore+=yarn.lock
set wildignore+=*.egg-info
set wildignore+=*/build/*

let g:deoplete#enable_at_startup = 1
let g:fzf_layout = { 'down': '~20%' }
let g:semanticTermColors = [104, 122, 152, 146, 167, 191, 137, 167, 23, 71, 130]

" }}}

" Mappings {{{

nnoremap ; :
cnoremap <F2> 
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap  :NERDTreeToggle
nnoremap <silent> <ESC> :noh
inoremap <silent> <ESC> <ESC>:noh
nmap  :FZF

" nmap x "_d
" nmap X "_D
" nmap XX "_DD
" nmap xx "_dd

nnoremap [e :lne
nnoremap ]e :lNe

" }}}

" Style {{{

hi IndentGuidesEven  ctermbg=236
hi IndentGuidesOdd ctermbg=236

hi StatusLine ctermbg=239 ctermfg=254
hi Visual ctermbg=239
hi LineNr ctermbg=234
hi ExtraWhitespace ctermfg=238

colorscheme tender

let g:airline_powerline_fonts = 1

hi VertSplit ctermfg=058
hi Comment cterm=italic

" }}}

" Project-specific {{{

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

" }}}

let g:android_sdk_path = "/home/alexcleac/Android/Sdk"
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
