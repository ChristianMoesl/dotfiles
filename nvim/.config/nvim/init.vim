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
Plug 'arcticicestudio/nord-vim'

" TUI Plugins
Plug 'ChristianMoesl/vim-airline', {'branch': 'tabline-buf-filter'} " status line (modes)
Plug 'psliwka/vim-smoothie'         " smooth scrolling
Plug 'scrooloose/nerdtree'          " file browser

" Git Plugins
Plug 'tpope/vim-fugitive'           " git baseline plugin
Plug 'airblade/vim-gitgutter'       " show modified lines and git hunk navigation
Plug 'Xuyuanp/nerdtree-git-plugin'  " git status in file browser

" Fuzzy file finder
Plug '/usr/local/opt/fzf'

" Better editing
Plug 'scrooloose/nerdcommenter'     " comment blocks
Plug 'tpope/vim-surround'           " change surrounding chars (e.g. ')
Plug 'tpope/vim-unimpaired'         " move lines and much more
Plug 'tpope/vim-repeat'             " . command for unimpaired/surround

" Session management
Plug 'tpope/vim-obsession'

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
nnoremap <leader>d :bd!<CR>

" navigate to buffers of same type only and 
" ignore this command in NERDTree buffers
function! SwitchBufToSameType(switch_fn)
  if bufname('%') =~# "^NERD_tree_"
    return
  endif

  let cwd = getcwd()
  let start_buffer = bufnr('%')
  let prev_buftype = &buftype
  execute a:switch_fn
  while (!(&buftype ==# prev_buftype) || !BufferIsInWorkspace(bufnr('%'), cwd)) && bufnr('%') != start_buffer
    execute a:switch_fn
  endwhile
endfunction

nnoremap <silent> ]b :call SwitchBufToSameType('bn')<CR>
nnoremap <silent> [b :call SwitchBufToSameType('bp')<CR>

function! BufferIsInWorkspace(nr, work_dir)
  let path = expand('#' . a:nr . ':p')

  return (len(nvim_list_tabpages()) < 2) || (path =~ a:work_dir) || (path =~# 'term://')
endfunction

function! ListBuffersInWorkspace(nr)
  let buffers = filter(nvim_list_bufs(), {_, b -> nvim_buf_is_loaded(b)})

  let buffers_in_workspace = filter(buffers, {_, nr -> BufferIsInWorkspace(nr, getcwd())})

  for buf in buffers_in_workspace
    if buf == a:nr
      return 0
    endif
  endfor

  return 1
endfunction

let g:AirlineTablineBufferFilter = function('ListBuffersInWorkspace')

" =====================================================================================
"                                  THEME
" =====================================================================================

" theme and color configuration
" let g:gruvbox_italic=1
let g:nord_uniform_diff_background = 1

" let g:airline_theme="github"
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1

" display buffer names without filepath for unique names
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#ignore_bufadd_pat = 'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'

" enable true colors
set termguicolors
syntax enable
set background=light
colorscheme nord

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

" Remove highlight of search when pressing ESC
nnoremap <silent> <esc> :noh<return><esc>


" =====================================================================================
"                                 Unimpaired
" =====================================================================================
" configure vim-unimpaired
nmap [l <Plug>unimpairedMoveUp
nmap ]l <Plug>unimpairedMoveDown
xmap [l <Plug>unimpairedMoveSelectionUp
xmap ]l <Plug>unimpairedMoveSelectionDown


" =====================================================================================
"                                    Test
" =====================================================================================
" Map shortcuts to run tests with vim-test
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>


" =====================================================================================
"                                 Auto Save
" =====================================================================================
let g:auto_save = 0  " enable AutoSave on Vim startup
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode


" =====================================================================================
"                                 Nerdtree
" =====================================================================================
noremap <leader>n :NERDTreeToggle<CR>

" disable netrw
let g:loaded_netrw = 0
let g:loaded_netrwPlugin = 1

let g:NERDTreeHijackNetrw=0
let g:NERDTreeShowHidden = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeChDirMode = 3 


" =====================================================================================
"                                FZF Plugin
" =====================================================================================
nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

nnoremap <silent> [fzf-p]p     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> <C-p>        :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> [fzf-p]b     :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>

let $BAT_THEME = 'Nord'
let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'Nord'


" =====================================================================================
"                                  Git
" =====================================================================================
" Command to checkout a Git branch with fuzzy search
function! s:ExecForBranch(command, branch)
  let full_command = a:command . ' "' . trim(substitute(escape(a:branch, '%#'), '*', '', 'g')) . '"'
  echo full_command
  execute full_command
endfunction

function! ExecForBranchFuzzy(command)
  echo a:command
  call fzf#run(fzf#wrap({'source': 'git branch','sink': {branch -> s:ExecForBranch(a:command, branch)}}))
endfunction

" fast Git shortcuts
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gca :Git commit --amend<CR>
nnoremap <leader>gl :Git log<CR>
nnoremap <leader>gd :Git diff<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gpf :Git push --force-with-lease<CR>
nnoremap <leader>gst :Git<CR>
nnoremap <silent> <leader>gsw :.call ExecForBranchFuzzy('Git switch')<CR>
nnoremap <silent> <leader>grbi :.call ExecForBranchFuzzy('Git rebase -i')<CR>
nnoremap <leader>grbm :Git rebase -i origin/master<CR>
nnoremap <leader>grbc :Git rebase --continue<CR>
nnoremap <leader>grba :Git rebase --abort<CR>


" =====================================================================================
"                                    COC 
" =====================================================================================
let g:coc_global_extensions = [
      \'coc-yaml', 
      \'coc-rust-analyzer', 
      \'coc-python',
      \'coc-metals',
      \'coc-vimlsp',
      \'coc-sh',
      \'coc-fzf-preview',
      \'coc-marketplace'
      \]

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
xmap <leader>fs  <Plug>(coc-format-selected)
nmap <leader>fs  <Plug>(coc-format-selected)

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
