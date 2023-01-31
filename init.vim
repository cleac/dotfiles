call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'vimwiki/vimwiki'
Plug 'jpalardy/vim-slime'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
call plug#end()

colorscheme slate

let mapleader = ","

nnoremap <silent> <leader>ce :tabnew ~/.config/nvim/init.vim<CR>
nnoremap <silent> <leader>d :noh<CR>
nnoremap <silent> <leader>t :NERDTreeToggle<CR>

inoremap ' "
inoremap " '

command! W normal :w<CR>
command! Wq normal :wq<CR>
command! Q normal :q!<CR>
command! Qa normal :qa!<CR>

au BufWritePost *.py exe "!flake8 %"
au BufWritePost *.lua exe "!lualint %"
au BufReadPre *.c set et sts=2 sw=2
au Syntax haskell set et sts=2 sw=2
au BufReadPre *.md,*.wiki,*.txt,*.rst set et sts=2 sw=2

au BufWritePre * %s/\ \+$//ge

set linebreak
set undofile
set number

function! AttachProjectConfig()
  if filereadable(".vimconfig")
    source .vimconfig
  endif
endfunction
if !exists("project_config_attach")
  let project_config_attach = 1
  autocmd VimEnter * call AttachProjectConfig()
endif

let g:vimwiki_list = [{'path': '~/vimwiki',
			\ 'syntax': 'markdown', 'ext': '.md'}]

