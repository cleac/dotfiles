call plug#begin('~/.config/nvim/plugged')
Plug 'wolf-dog/nighted.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
" Plug 'editorconfig/editorconfig-vim'
" Plug 'neomake/neomake'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'vimwiki/vimwiki'
call plug#end()

colorscheme nighted

function! EditConfig()
tabnew ~/.config/nvim/init.vim
endfunction

let mapleader = ","

nnoremap <silent> <leader>ce :call EditConfig()<CR>
nnoremap <silent> ,d :noh<CR>
nnoremap <silent> ,t :NERDTreeToggle<CR> 

au BufWritePost *.py exe "!flake8 %"
au BufWritePost *.lua exe "!lualint %"
au BufReadPre *.c set et sts=2 sw=2
au BufReadPre *.md,*.wiki,*.txt,*.rst set et sts=2 sw=2 

au BufWritePre * %s/\ \+$//ge

set linebreak
set undofile

let g:vimwiki_list = [{'path': '~/wiki', 'syntax': 'markdown' }]
