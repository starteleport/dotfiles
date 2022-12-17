" VIM configuration file
"

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" Set this to 1 to use ultisnips for snippet handling
let s:using_snippets = has('python3')
let g:OmniSharp_server_use_net6 = 1

" Use my own customizations that are shared between VIM/NVIM
source ~/.vimrc.common

" vim-plug: {{{
call plug#begin('~/.vim/plugged')

" Vim FZF integration, used as OmniSharp selector
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Statusline
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'maximbaz/lightline-ale'

Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/gruvbox-material'

Plug 'preservim/nerdtree'
Plug 'OmniSharp/omnisharp-vim'

" Mappings, code-actions available flag and statusline integration
Plug 'nickspoons/vim-sharpenup'

" Linting/error highlighting
Plug 'dense-analysis/ale'

" Autocompletion
Plug 'prabirshrestha/asyncomplete.vim'

" Snippet support
if s:using_snippets
  Plug 'sirver/ultisnips'
endif

Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

call plug#end()
" }}}

let g:OmniSharp_loglevel = "debug"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Sessions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:session_autosave_periodic = 1
let g:session_autosave_silent = 1
let g:session_autoload = 'yes'
" The following uses the directory name as a session name to support directory-based sessions
let g:session_default_name = fnamemodify(getcwd(), ':t')

" Looks like it's not so frequent
"nnoremap <leader>wsn :SaveSession<CR> " Start new session
"nnoremap <leader>wsd :DeleteSession<CR> " Delete the session

" Tree plugins: {{{
"
"" NERDTree

"" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <leader>nt :NERDTreeMirror<CR>:NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
nnoremap <leader>nn :NERDTreeMirror<CR>:NERDTreeFocus<CR>

let g:NERDTreeMinimalMenu=1

augroup NERDTree
  autocmd!
  " Close the tab if NERDTree is the only window remaining in it.
  autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

  " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
  autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
      \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
augroup END
" }}}

" Settings: {{{
" 
" Most part of the settings is in .vimrc.common, 
" we just place overrides/customizations here

set completeopt=menuone,noinsert,noselect,popuphidden
set completepopup=highlight:Pmenu,border:off

" }}}

" Colors: {{{

augroup ColorschemePreferences
  autocmd!
  " These preferences clear some gruvbox background colours, allowing transparency
  autocmd ColorScheme * highlight Normal     ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight Todo       ctermbg=NONE guibg=NONE
  " Link ALE sign highlights to similar equivalents without background colours
  autocmd ColorScheme * highlight link ALEErrorSign   WarningMsg
  autocmd ColorScheme * highlight link ALEWarningSign ModeMsg
  autocmd ColorScheme * highlight link ALEInfoSign    Identifier
augroup END

colorscheme gruvbox-material
" }}}

" ALE: {{{
let g:ale_sign_error = '•'
let g:ale_sign_warning = '•'
let g:ale_sign_info = '·'
let g:ale_sign_style_error = '·'
let g:ale_sign_style_warning = '·'

let g:ale_linters = { 'cs': ['OmniSharp'] }

nmap <silent> [d <Plug>(ale_previous_wrap)
nmap <silent> ]d <Plug>(ale_next_wrap)

" }}}

" Asyncomplete: {{{
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
" }}}

" Sharpenup: {{{
" All sharpenup mappings will begin with `<Space>os`, e.g. `<Space>osgd` for
" :OmniSharpGotoDefinition
let g:sharpenup_map_prefix = '<localleader>o'

let g:sharpenup_statusline_opts = { 'Text': '%s (%p/%P)' }
let g:sharpenup_statusline_opts.Highlight = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => OmniSharp extensions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:map(mode, lhs, rhs) abort
  if !hasmapto(a:rhs, substitute(a:mode, 'x', 'v', ''))
  \ && maparg(a:lhs, a:mode) ==# ''
      execute a:mode . 'map <silent> <buffer>' a:lhs a:rhs
  endif
endfunction

function! s:StartOmniSharpIfSlnIsInCwd() abort
  let s:solution_files = readdir(getcwd(-1), {n -> n =~ '.sln$'})
  if len(s:solution_files) == 1
    call OmniSharp#StartServer(s:solution_files[0], 1)
    let s:pre = get(g:, 'sharpenup_map_prefix', "\<LocalLeader>os")

    command! -bar -nargs=? MyFindSymbol call OmniSharp#actions#symbols#Find(<q-args>)
    command! -bar -nargs=? MyFindType call OmniSharp#actions#symbols#FindType(<q-args>)

    call s:map('n', s:pre . 'fs', ':MyFindSymbol')
    call s:map('n', s:pre . 'ft', ':MyFindType')
  endif
endfunction

augroup OmniSharpAutoStart
  autocmd!
  autocmd VimEnter * call s:StartOmniSharpIfSlnIsInCwd() 
  autocmd DirChanged global call s:StartOmniSharpIfSlnIsInCwd() 
augroup END

augroup OmniSharpIntegrations
  autocmd!
  autocmd User OmniSharpStarted,OmniSharpProjectUpdated,OmniSharpReady,OmniSharpStopped call lightline#update()
augroup END

" }}}

" Lightline: {{{
let g:lightline = {
\ 'colorscheme': 'gruvbox_material',
\ 'active': {
\   'right': [
\     ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
\     ['lineinfo'], ['percent'],
\     ['fileformat', 'fileencoding', 'filetype', 'sharpenup']
\   ]
\ },
\ 'inactive': {
\   'right': [['lineinfo'], ['percent'], ['sharpenup']]
\ },
\ 'component': {
\   'sharpenup': sharpenup#statusline#Build()
\ },
\ 'component_expand': {
\   'linter_checking': 'lightline#ale#checking',
\   'linter_infos': 'lightline#ale#infos',
\   'linter_warnings': 'lightline#ale#warnings',
\   'linter_errors': 'lightline#ale#errors',
\   'linter_ok': 'lightline#ale#ok'
  \  },
  \ 'component_type': {
  \   'linter_checking': 'right',
  \   'linter_infos': 'right',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'right'
\  }
\}
" Use unicode chars for ale indicators in the statusline
let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_infos = "\uf129 "
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c "
" }}}

" OmniSharp: {{{
let g:OmniSharp_popup_position = 'peek'
let g:OmniSharp_popup_options = {
\ 'highlight': 'Normal',
\ 'padding': [0],
\ 'border': [1],
\ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
\ 'borderhighlight': ['ModeMsg']
\}
let g:OmniSharp_popup_mappings = {
\ 'sigNext': '<C-n>',
\ 'sigPrev': '<C-p>',
\ 'pageDown': ['<C-f>', '<PageDown>'],
\ 'pageUp': ['<C-b>', '<PageUp>']
\}

if s:using_snippets
  let g:OmniSharp_want_snippet = 1
endif

let g:OmniSharp_highlight_groups = {
\ 'ExcludedCode': 'NonText'
\}
" }}}
