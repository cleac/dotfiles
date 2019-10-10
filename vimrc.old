set nocompatible

" Plugins {{{

call plug#begin('~/.vim/plugged')

    " Misc editor view improvements
    " Plug 'http://github.com/airblade/vim-gitgutter'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'kshenoy/vim-signature'
    Plug 'wilywampa/vim-commentary'
    Plug 'editorconfig/editorconfig-vim'

    " Navigation
    Plug 'http://github.com/scrooloose/nerdtree'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'majutsushi/tagbar', {'on': 'Tagbar'}

    " Easier editing
    Plug 'tpope/vim-surround'

    " Syntaxes
    Plug 'http://github.com/wavded/vim-stylus', { 'for': ['stylus', '*.sss'] }
    Plug 'Glench/Vim-Jinja2-Syntax'
    Plug 'othree/html5.vim', { 'for': ['html', 'html5'] }
    Plug 'isruslan/vim-es6'
    Plug 'vim-scripts/mako.vim'
    Plug 'kchmck/vim-coffee-script', {'for': ['coffee']}
    Plug 'leafgarland/typescript-vim', {'for': ['typescript']}
    Plug 'vim-scripts/cmake.vim-syntax'

    " Text objects
    Plug 'kana/vim-textobj-user'
    Plug 'glts/vim-textobj-comment'
    Plug 'lucapette/vim-textobj-underscore'
    Plug 'kana/vim-textobj-entire'
    Plug 'thinca/vim-textobj-between'

    " Linting
    Plug 'neomake/neomake'

    " Theme
    Plug 'sjl/badwolf'
    Plug 'morhetz/gruvbox'

    " LSP support
    Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh', 'on': []}

call plug#end()

" }}}

" Autocommands {{{

fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    autocmd BufWritePre * :call CleanExtraSpaces()
    autocmd VimEnter * IndentGuidesEnable

    autocmd FileType python setlocal tw=79 softtabstop=4 ts=4 sw=4 et
    autocmd Syntax python setlocal tw=79 softtabstop=4 ts=4 sw=4 et
    autocmd Syntax text setlocal tw=0 wrap nonumber
    autocmd FileType text setlocal tw=0 wrap nonumber
    autocmd Syntax markdown setlocal tw=0 wrap nonumber
    autocmd FileType markdown setlocal tw=0 wrap nonumber
    autocmd Syntax lua setlocal softtabstop=2 ts=2 sw=2 et
    autocmd FileType lua setlocal softtabstop=2 ts=2 sw=2 et
    autocmd Syntax javascript setlocal softtabstop=2 ts=2 sw=2 et fdm=syntax
    autocmd FileType javascript setlocal softtabstop=2 ts=2 sw=2 et fdm=syntax

    autocmd BufRead *.mako setf mako
    autocmd BufRead *.sss setf stylus

    autocmd CompleteDone * pclose
endif

" }}}

" Global setup {{{

set tw=119
let &l:colorcolumn = '+' . join(range(1, 255), ',+')
set  cindent hlsearch ic incsearch
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
set laststatus=2
set scrolloff=5
set fdm=marker fmr={{{,}}}
set laststatus=2
set timeout timeoutlen=500 ttimeoutlen=200
set softtabstop=2 ts=2 sw=2 et si ai smarttab
filetype on

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

let g:fzf_layout = { 'down': '~20%' }
" let g:semanticTermColors = [104, 122, 152, 146, 167, 191, 137, 167, 23, 71, 130]
"
let g:android_sdk_path = "/home/alexcleac/Android/Sdk"

call neomake#configure#automake('w', 1000)
let g:neomake_javascript_enabled_makers = ['eslint']
" let g:neomake_python_flake8_exe = 'flake8-3'

let g:slime_target = "tmux"

" }}}

" Mappings {{{

" Modal shortcuts
nnoremap <silent> <C-s> :w
nnoremap <silent> <C-q> :q
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <silent>  :NERDTreeToggle
nnoremap <silent> <ESC> :noh
nmap <silent>  :FZF
nnoremap <silent> <C-t> :Tagbar
nnoremap <silent> <C-C><C-X> :call plug#load('coc.nvim')

" Copy to global
map gy "+y
map gY "+Y

" Errors navigation
nnoremap [e :lne
nnoremap ]e :lNe

" To be done part
nnoremap <Space><Space> i<TBD><Esc>
nnoremap gb /<TBD><Esc>
nnoremap gB ?<TBD><Esc>
nnoremap cgb /<TBD><Esc>ca>
nnoremap cgB ?<TBD><Esc>ca>

" Navigating to import statement in Python
nnoremap go #ggN
nnoremap gof #ggNgf

" Opening terminal in split
nnoremap <C-w>gp v:terminal<CR>
nnoremap <C-w>gP v:terminal<Space>

" Light/dark scheme changing
nnoremap <silent> gsd :set<SPACE>background=dark<CR>
nnoremap <silent> gsD :set<SPACE>background=light<CR>

" }}}

" Style {{{

colorscheme gruvbox

" hi IndentGuidesEven ctermbg=235
" hi IndentGuidesOdd ctermbg=235

" hi LineNr ctermbg=235

" hi VertSplit ctermfg=058
hi Comment cterm=italic

let g:airline_theme='gruvbox'

set background=dark

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
