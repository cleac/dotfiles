set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set ts=4 sw=4 et

call plug#begin('~/.vim/plugged')

Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'http://github.com/airblade/vim-gitgutter'
Plug 'http://github.com/scrooloose/nerdtree'
Plug 'http://github.com/wavded/vim-stylus'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'kien/ctrlp.vim'
Plug 'jacoborus/tender.vim'
Plug 'nathanaelkane/vim-indent-guides'

call plug#end()

set t_Co=256
set mouse=a

filetype on
filetype plugin on

let g:flake8_show_in_gutter = 1

set cindent
set hlsearch
set ic
set incsearch
set number
syntax on
set guifont="Droid Sans Mono":h20
set backspace=indent,eol,start

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_python_checkers=['pyflakes']

let NERDTreeIgnore = ['*\.pyc', '__pycache__', 'celerybeat-schedule', 'node_modules']

set laststatus=2

colorscheme tender

set timeout timeoutlen=1000 ttimeoutlen=100

set wildignore+=*/node_modules/*
set wildignore+=*/__pycache__/*
set wildignore+=*.pyc

let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 4

let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=236
hi IndentGuidesEven ctermbg=238

" IndentGuidesEnable " TODO: Find a way to make IndentGuides autostart
