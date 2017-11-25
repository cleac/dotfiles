set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Plugins {{{

call plug#begin('~/.vim/plugged')
    Plug 'http://github.com/airblade/vim-gitgutter'
    Plug 'http://github.com/scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTree'] }
    Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTree'] }
    Plug 'http://github.com/wavded/vim-stylus', { 'for': 'stylus' }
    Plug 'tpope/vim-surround'
    Plug 'Glench/Vim-Jinja2-Syntax', {'for': ['jinja', 'html'] }
    Plug 'nathanaelkane/vim-indent-guides'
    " Plug 'w0rp/ale'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
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
    " Plug 'jaxbot/semantic-highlight.vim'
    Plug 'tpope/vim-eunuch'
    Plug 'artur-shaik/vim-javacomplete2'
    Plug 'hsanson/vim-android', {'for': ['java'. 'groovy'. 'scala']}
    Plug 'tfnico/vim-gradle', {'for': ['java'. 'groovy'. 'scala']}
    Plug 'zchee/deoplete-clang', { 'for': ['c', 'cpp', 'c++'] }
    Plug 'kchmck/vim-coffee-script'
    Plug 'mrinterweb/vim-visual-surround'
    Plug 'raimondi/delimitmate'
    Plug 'vim-scripts/matchit.zip'
    Plug 'nanotech/jellybeans.vim'
    Plug 'kien/rainbow_parentheses.vim'
    Plug 'terryma/vim-expand-region'
    Plug 'junegunn/goyo.vim'
    Plug 'valloric/matchtagalways'
    Plug 'osyo-manga/vim-over'
    Plug 'vimwiki/vimwiki'
    Plug 'sjl/badwolf'
    Plug 'majutsushi/tagbar'
    " Plug 'vim-syntastic/syntastic'
    Plug 'neomake/neomake'
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

let g:ale_linters = {
            \ 'javascript': ['eslint'],
            \ }


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
" let g:semanticTermColors = [104, 122, 152, 146, 167, 191, 137, 167, 23, 71, 130]
"
let g:android_sdk_path = "/home/alexcleac/Android/Sdk"
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'

" let g:syntastic_always_populate_loc_list = 1
" " let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_aggregate_errors = 1

call neomake#configure#automake('nw', 1000)
let g:neomake_javascript_enabled_makers = ['eslint']

if has("gui_running")
    set guifont=Source\ Code\ Pro\ 10
endif

" }}}

" Mappings {{{

nnoremap <C-s> :w
nnoremap <C-q> :q
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <silent>  :NERDTreeToggle
nnoremap <silent> <ESC> :noh
inoremap <silent> <ESC> <ESC>:noh
nmap <silent>  :FZF
nnoremap <silent> <C-t> :Tagbar
map gy "+y
map gY "+Y

nnoremap [e :lne
nnoremap ]e :lNe
nnoremap gb /<TBD><Esc>
nnoremap gB ?<TBD><Esc>
nnoremap cgb /<TBD><Esc>ca>
nnoremap cgB ?<TBD><Esc>ca>

" }}}

" Style {{{

hi IndentGuidesEven ctermbg=235
hi IndentGuidesOdd ctermbg=235

" hi StatusLine ctermbg=239 ctermfg=254
" hi Visual ctermbg=239
" hi LineNr ctermbg=234
" hi ExtraWhitespace ctermfg=238

colorscheme badwolf

" hi VertSplit ctermfg=058
hi Comment cterm=italic

let g:airline_theme='badwolf'

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
