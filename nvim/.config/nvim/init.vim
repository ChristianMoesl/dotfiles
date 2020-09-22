" =====================================================================================
"                                 PLUGINS
" =====================================================================================

call plug#begin('~/.local/share/nvim/plugged')

" Themes
Plug 'cormacrelf/vim-colors-github'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'romainl/Apprentice'
Plug 'jacoborus/tender.vim'

" TUI Plugins
Plug 'vim-airline/vim-airline'      " status line (modes)
Plug 'psliwka/vim-smoothie'         " smooth scrolling
Plug 'scrooloose/nerdtree'          " file browser
Plug 'Xuyuanp/nerdtree-git-plugin'  " git status in file browser
Plug 'tpope/vim-fugitive'           " use git in vim

" Fuzzy file finder
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" Better editing
Plug 'scrooloose/nerdcommenter'     " comment blocks
Plug 'airblade/vim-gitgutter'       " display modified lines
Plug 'tpope/vim-surround'           " change surrounding chars (e.g. ')
Plug 'tpope/vim-unimpaired'         " move lines and much more
Plug 'tpope/vim-repeat'             " . command for unimpaired/surround
Plug '907th/vim-auto-save'          " automatically safe files while editing

" Session management
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'

" Plugins for programming languages
Plug 'neoclide/coc.nvim', {'branch': 'release'}   " language protocol client
Plug 'vim-test/vim-test'                          " run tests with vim
Plug 'derekwyatt/vim-scala'                       " server for Scala
Plug 'leafgarland/typescript-vim'                 " server for typescript
Plug 'peitalin/vim-jsx-typescript'                " syntax highlighter for ts/tsx
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  } " markdown preview in browser

call plug#end()

" =====================================================================================
"                                  BASIC
" =====================================================================================

" neovim basic settings
set number relativenumber
set cursorline
set splitbelow
set splitright

" identation settings
set smartindent
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" =====================================================================================
"                                  BUFFER
" =====================================================================================

" buffer settings
" if hidden is not set, TextEdit might fail.
set hidden

" delete buffer with a shortcut
nnoremap <leader>d :bp\|bd! #<CR>

" navigate to buffers of same type only and 
" ignore this command in NERDTree buffers
function! BnToSameType()
  if bufname('%') =~# "^NERD_tree_"
    return
  endif

  let start_buffer = bufnr('%')
  let prev_buftype = &buftype
  bn
  while !(&buftype ==# prev_buftype) && bufnr('%') != start_buffer
    bn
  endwhile
endfunction

function! BpToSameType()
  if bufname('%') =~# "^NERD_tree_"
    return
  endif

  let start_buffer = bufnr('%')
  let prev_buftype = &buftype
  bp 
  while !(&buftype ==# prev_buftype) && bufnr('%') != start_buffer
    bp
  endwhile
endfunction

nnoremap <silent> ]b :call BnToSameType()<CR>
nnoremap <silent> [b :call BpToSameType()<CR>

let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode

" =====================================================================================
"                                  THEME
" =====================================================================================

" theme and color configuration
" enable true colors
set termguicolors
syntax enable
set background=light
colorscheme github
" let g:gruvbox_italic=1

let g:airline_theme="github"
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1

" display buffer names without filepath for unique names
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#ignore_bufadd_pat = 'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'

" =====================================================================================
"                                KEYMAPPINGS
" =====================================================================================

" shortcut to open terminal in split
nnoremap <leader>t :vsplit<CR>:terminal<CR>
vnoremap <leader>t :vsplit<CR>:terminal<CR>

" Easier split navigation (omit C-W) in all modes
" Normal Mode:
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Insert Mode:
inoremap <C-J> <Esc><C-W><C-J>
inoremap <C-K> <Esc><C-W><C-K>
inoremap <C-L> <Esc><C-W><C-L>
inoremap <C-H> <Esc><C-W><C-H>
" Visual Mode:
vnoremap <C-J> <Esc><C-W><C-J>
vnoremap <C-K> <Esc><C-W><C-K>
vnoremap <C-L> <Esc><C-W><C-L>
vnoremap <C-H> <Esc><C-W><C-H>
" Terminal Mode:
tnoremap <C-J> <C-\><C-n><C-W><C-J>
tnoremap <C-K> <C-\><C-n><C-W><C-K>
tnoremap <C-L> <C-\><C-n><C-W><C-L>
tnoremap <C-H> <C-\><C-n><C-W><C-H>

" resize windows
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

" Fix shortcuts in terminal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <leader><Esc> <Esc>

nmap [l <Plug>unimpairedMoveUp
nmap ]l <Plug>unimpairedMoveDown
xmap [l <Plug>unimpairedMoveSelectionUp
xmap ]l <Plug>unimpairedMoveSelectionDown

" Remove highlight of search when pressing ESC
nnoremap <esc> :noh<return><esc>

" Map shortcuts to run tests with vim-test
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

" =====================================================================================
"                                 Nerdtree
" =====================================================================================
noremap <leader>n :NERDTreeToggle<CR>

let g:NERDTreeShowHidden = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeChDirMode = 3

" =====================================================================================
"                                FZF Plugin
" =====================================================================================
nnoremap <silent> <c-p>  :Files<cr>

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'


" =====================================================================================
"                                    COC 
" =====================================================================================

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use `[e` and `]e` to navigate errors
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" Configure filetype detection
au BufRead,BufNewFile *.sbt set filetype=scala
au BufRead,BufNewFile *.tsx set filetype=typescript.tsx
au BufRead,BufNewFile *.jsx set filetype=javascript.jsx
