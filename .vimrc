set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

call plug#begin('~/.vim/plugged')

Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'jpo/vim-railscasts-theme'
Plug 'https://github.com/nvie/vim-flake8'
Plug 'https://github.com/airblade/vim-gitgutter'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/wavded/vim-stylus'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'Glench/Vim-Jinja2-Syntax'

call plug#end()

set t_Co=256
set mouse=a

filetype on
filetype plugin on

let g:flake8_show_in_file = 1
let g:flake8_show_in_gutter = 1

set cindent
set hlsearch
set ic
set incsearch
set number
syntax on
set guifont="Droid Sans Mono":h20
set backspace=indent,eol,start
colorscheme slate

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_flake8_args="--ignore=F401,E128,W391,E124"

