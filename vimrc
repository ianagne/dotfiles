" Leader
let mapleader = "\<Space>"

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set ignorecase    " case insensitive searching
set smartcase     " overrides ignorecase when pattern contains caps

" Crosshair highlighting!
set cursorline
set cursorcolumn

" I don't want to do math at 8am - Use hybrid number mode
set relativenumber
set number

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufNewFile,BufRead *.slim setlocal filetype=slim
  autocmd BufNewFile,BufRead *.slime setlocal filetype=slim
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" FZF
nnoremap <C-p> :Files<cr>
let g:fzf_files_options =
  \ '--reverse ' .
  \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  nnoremap <C-F> :Ag<cr>
  " Use Ag over Grep
  set grepprg=ag\ --nocolor
  let $FZF_DEFAULT_COMMAND='ag -g "" --hidden'
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

command! -nargs=* VT vsplit | terminal <args>
nnoremap <silent> <Leader>g :VT<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Use neoterm for vim-test
let test#strategy='neoterm'

" Use a vertical split when opening terminal for tests
let g:neoterm_default_mod = "vertical"

nnoremap <Leader>ra :%s/

" Move cursor by displayed lines vs line numbers
nnoremap j gj
nnoremap k gk

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>n :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <leader>gt :TestVisit<CR>

" :e to the current directory
nnoremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Quickly split panes
nnoremap <Leader>v :vsplit<CR>

" # coc.nvim config

let g:coc_global_extensions = [
  \ 'coc-solargraph',
\ ]

" navigate the autocomplete options with tab and shift-tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <esc> pumvisible() ? "\<esc>\<esc>" : "\<esc>"

" enter key will select the autocomplete option
let g:endwise_no_mappings = 1
imap <C-X><CR>   <CR><Plug>AlwaysEnd
imap <expr> <CR> (pumvisible() ? "\<C-Y>\<Plug>DiscretionaryEnd" : "\<CR>\<Plug>DiscretionaryEnd")

" # ALE Config

" Only run linters that have been turned on
" Otherwise, the code will be fixed, but full of linter errors
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1 " Fix files on save
let g:ale_linters = {
      \ 'elixir': ['credo', 'dialyxir'],
      \ 'ruby': ['standardrb'],
      \}
let g:ale_fixers = {
      \  '*': ['remove_trailing_lines', 'trim_whitespace'],
      \'elixir': ['mix_format'],
      \'javascript': ['prettier'],
      \'json': ['prettier'],
      \'ruby': ['standardrb'],
      \'vue': ['prettier'],
      \'scss': ['prettier'],
      \}

" Quicker window movement
nnoremap <C-j> <c-w>j
nnoremap <C-k> <c-w>k
nnoremap <C-h> <c-w>h
nnoremap <C-l> <c-w>l

" Quicker saving
nnoremap <Leader>s <esc>:w<CR>

" Map ; to : so I don't have to hold shift for vim commands
nnoremap : ;
nnoremap ; :

if has('nvim')
  " Use ESC to exit terminal
  tnoremap <Esc> <C-\><C-n>
  " Easier navigation between terminal and other panes
  tnoremap <c-h> <c-\><c-n><c-w>h
  tnoremap <c-l> <c-\><c-n><c-w>l
endif

colorscheme jellybeans
