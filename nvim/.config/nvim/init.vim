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
Plug 'liuchengxu/vim-which-key'     " display help for key mappings

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
Plug 'leafgarland/typescript-vim'                 " server for typescript
Plug 'peitalin/vim-jsx-typescript'                " syntax highlighter for ts/tsx
Plug 'cespare/vim-toml'                           " syntax highlighter for toml
Plug 'nbouscal/vim-stylish-haskell'               " code formater for Haskell
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

" Define prefix dictionary
let g:which_key_map =  {}

" =====================================================================================
"                                  BUFFER
" =====================================================================================

" buffer settings
" if hidden is not set, TextEdit might fail.
set hidden


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

  return start_buffer == bufnr('%')
endfunction

function! DeleteBufferAnMoveToPrev()
  let start_buffer = bufnr('%')

  let success = SwitchBufToSameType('bp')

  if !success | execute 'bp' | endif

  execute 'bd! ' . start_buffer
endfunction

function! BufferIsInWorkspace(nr, work_dir)
  let path = expand('#' . a:nr . ':p')

  return (len(nvim_list_tabpages()) < 2) || (path =~ a:work_dir) || (path =~# 'term://')
endfunction

function! ListBuffersInWorkspace(nr)
  let buffers = filter(nvim_list_bufs(), {_, b -> nvim_buf_is_loaded(b)})

  let buffers_in_workspace = filter(buffers, {_, nr -> BufferIsInWorkspace(nr, getcwd())})

  for buf in buffers_in_workspace
    if buf == a:nr | return 0 | endif
  endfor

  return 1
endfunction

function! CloseAllBuffersButCurrent()
  let curr = bufnr("%")
  let last = bufnr("$")

  if curr > 1    | silent! execute "1,".(curr-1)."bd"     | endif
  if curr < last | silent! execute (curr+1).",".last."bd" | endif
endfunction

let g:AirlineTablineBufferFilter = function('ListBuffersInWorkspace')

nnoremap <silent> ]b :call SwitchBufToSameType('bn')<CR>
nnoremap <silent> [b :call SwitchBufToSameType('bp')<CR>

" delete buffer with a shortcut
nnoremap <leader>bc :call DeleteBufferAnMoveToPrev()<CR>
nnoremap <leader>bC :call CloseAllBuffersButCurrent()<CR>

let g:which_key_map.b = {
      \ 'name' : '+buffer',
      \ 'c' : 'buffer-close-current',
      \ 'C' : 'buffer-close-other',
      \ }

" =====================================================================================
"                                  WINDOW
" =====================================================================================

nnoremap <leader>wo :only<CR>

let g:which_key_map.w = {
      \ 'name' : '+window',
      \ 'o' : 'window-only',
      \ }


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
nnoremap <leader>ts :vsplit<CR>:terminal<CR>
vnoremap <leader>ts :vsplit<CR>:terminal<CR>

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
nnoremap <Up> :resize +5<CR>
nnoremap <Down> :resize -5<CR>
nnoremap <Left> :vertical resize +5<CR>
nnoremap <Right> :vertical resize -5<CR>

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
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>

let g:which_key_map.t = {
      \ 'name' : '+test',
      \ 'n' : 'test-nearest',
      \ 'f' : 'test-file',
      \ 's' : 'test-suite',
      \ 'l' : 'test-last',
      \ 'v' : 'test-visit',
      \ }

" =====================================================================================
"                                 Auto Save
" =====================================================================================
let g:auto_save = 0  " enable AutoSave on Vim startup
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode


" =====================================================================================
"                                 Nerdtree
" =====================================================================================
noremap <leader>n :NERDTreeToggle<CR>

let g:which_key_map.n = 'nerd-tree-toggle'

" disable netrw
let g:loaded_netrw = 0
let g:loaded_netrwPlugin = 1

let g:NERDTreeHijackNetrw=0
let g:NERDTreeShowHidden = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeChDirMode = 3 

" =====================================================================================
"                                 NERDCommenter
" =====================================================================================
let g:which_key_map.c = {
      \ 'name' : '+comment',
      \ ' ' : 'comment-toggle',
      \ '$' : 'comment-to-eol',
      \ 'a' : 'comment-alt-delims',
      \ 'A' : 'comment-append',
      \ 'b' : 'comment-align-both',
      \ 'c' : 'comment',
      \ 'i' : 'comment-invert',
      \ 'l' : 'comment-align-left',
      \ 'm' : 'comment-minimal',
      \ 'n' : 'comment-nested',
      \ 's' : 'comment-sexy',
      \ 'u' : 'uncomment',
      \ 'y' : 'comment-yank',
      \ }

" =====================================================================================
"                                FZF Plugin
" =====================================================================================
nnoremap <silent> <Leader>fp     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> <C-p>        :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> <Leader>fgs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> <Leader>fga    :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> <Leader>fg;    :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> <Leader>fb     :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> <Leader>fB     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> <Leader>fo     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> <Leader>f<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> <Leader>f/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> <Leader>f*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          <Leader>fP     :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          <Leader>fP     "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> <Leader>ft     :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> <Leader>fq     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> <Leader>fl     :<C-u>CocCommand fzf-preview.LocationList<CR>

let $BAT_THEME = 'Nord'
let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'Nord'

let g:which_key_map.f = {
      \ 'name' : '+find',
      \ 'p' : 'find-project-resources',
      \ 'P' : 'find-project-grep',
      \ 'g' : {
        \ 'name' : '+git',
        \ 's' : 'find-git-status',
        \ 'a' : 'find-git-actions',
        \ ';' : 'find-git-changes',
        \ },
      \ 'b' : 'find-buffers',
      \ 'B' : 'find-all-buffers',
      \ 'o' : 'find-buffers-and-project',
      \ '/' : 'find-lines',
      \ '*' : 'find-lines-extended',
      \ 't' : 'find-buffer-tags',
      \ 'q' : 'find-quickfix-list',
      \ 'l' : 'find-location-list',
      \ '<C-O>' : 'find-jumps',
      \ }

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
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gC :Git commit --amend<CR>
nnoremap <leader>gl :Git log<CR>
nnoremap <leader>gd :Git diff<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gB :Git switch -c 
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gP :Git push --force-with-lease<CR>
nnoremap <leader>gf :Git fetch<CR>
nnoremap <leader>gF :Git pull<CR>
nnoremap <leader>gs :Git<CR>
nnoremap <silent> <leader>gS :.call ExecForBranchFuzzy('Git switch')<CR>
nnoremap <silent> <leader>gri :.call ExecForBranchFuzzy('Git rebase -i')<CR>
nnoremap <leader>grm :Git rebase -i origin/master<CR>
nnoremap <leader>grc :Git rebase --continue<CR>
nnoremap <leader>gra :Git rebase --abort<CR>

let g:gitgutter_map_keys = 0

nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

nmap <leader>ghs <Plug>(GitGutterStageHunk)
nmap <leader>ghu <Plug>(GitGutterUndoHunk)
nmap <leader>ghp <Plug>(GitGutterPreviewHunk)
    
let g:which_key_map.g = {
      \ 'name' : '+git',
      \ 'b' : 'blame',
      \ 'B' : 'switch-create',
      \ 'w' : 'stage-buffer',
      \ 'c' : 'commit',
      \ 'C' : 'commit-amend',
      \ 'd' : 'diff-buffer-split',
      \ 'h' : {
        \ 'name' : '+hunk',
        \ 'p' : 'hunk-preview',
        \ 's' : 'hunk-stage',
        \ 'u' : 'hunk-undo',
        \ },
      \ 'l' : 'log',
      \ 'p' : 'push',
      \ 'P' : 'push-force',
      \ 'f' : 'fetch',
      \ 'F' : 'pull',
      \ 's' : 'status',
      \ 'S' : 'switch',
      \ 'r' : {
        \ 'name' : '+rebase',
        \ 'i' : 'rebase',
        \ 'm' : 'rebase-on-master',
        \ 'c' : 'rebase-continue',
        \ 'a' : 'rebase-abort',
        \ }
      \ }

" =====================================================================================
"                                    COC 
" =====================================================================================
let g:coc_global_extensions = [
      \'coc-clangd',
      \'coc-yaml', 
      \'coc-rust-analyzer', 
      \'coc-python',
      \'coc-metals',
      \'coc-vimlsp',
      \'coc-sh',
      \'coc-fzf-preview',
      \'coc-marketplace',
      \'coc-texlab'
      \]

" <silent> Some servers have issues with backup files, see #649
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

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

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
"nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

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

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>rf  <Plug>(coc-format-selected)
nmap <leader>rf  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>ra  <Plug>(coc-codeaction-selected)
nmap <leader>ra  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>rA  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>rq  <Plug>(coc-fix-current)

let g:which_key_map.r = {
      \ 'name' : '+refactor',
      \ 'a' : 'codeaction',
      \ 'A' : 'codeaction-current-buffer',
      \ 'f' : 'format-selected',
      \ 'n' : 'rename',
      \ 'q' : 'auto-fix-current',
      \ }


" Configure filetype detection
au BufRead,BufNewFile *.sbt set filetype=scala
au BufRead,BufNewFile *.tsx set filetype=typescript.tsx
au BufRead,BufNewFile *.jsx set filetype=javascript.jsx

" Configure clang-format on file save
function! ClangFormatOnSave()
  let l:formatdiff = 1
  py3f /usr/local/opt/llvm/share/clang/clang-format.py
endfunction

autocmd BufWritePre *.h,*.c,*.cpp call ClangFormatOnSave()

let g:stylish_haskell_command='stylish-haskell'

" =====================================================================================
"                                    Which Key 
" =====================================================================================
nnoremap <silent> <leader> :<c-u>WhichKey '\'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '\'<CR>

" By default timeoutlen is 1000 ms
set timeoutlen=500

call which_key#register('\', 'g:which_key_map')
