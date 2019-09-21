let g:ctrlp_show_hidden = 1

" neovim settings
set number
set cursorline
set smartindent
set splitbelow
set splitright

" Easier split navigation (omit C-W)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-Down> <C-W><C-J>
nnoremap <C-Up> <C-W><C-K>
nnoremap <C-Right> <C-W><C-L>
nnoremap <C-Left> <C-W><C-H>

call plug#begin('~/.local/share/nvim/plugged')

Plug 'vimlab/split-term.vim'
Plug 'leafgarland/typescript-vim'
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'plasticboy/vim-markdown'
Plug 'vim-airline/vim-airline'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'lervag/vimtex'

call plug#end()

colorscheme gruvbox
