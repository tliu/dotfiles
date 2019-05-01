" Don't rely on this file being named .vimrc to switch compatible mode off.
" Otherwise, people can't try this vimrc out using "vim -u path/to/this/vimrc"
set nocompatible

filetype on
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim' " let Vundle manage Vundle, required
Plugin 'tpope/vim-fugitive'
Plugin 'itchyny/lightline.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'smancill/conky-syntax.vim'
Plugin 'alderz/smali-vim'
Plugin 'jeroenbourgois/vim-actionscript'
call vundle#end()
" enable filetype detection, plus loading of filetype plugins
filetype plugin on

" Let vim change the title of the terminal window
set title

" Hide buffers instead of closing them
set hidden

" Show wildmenu for vim-command tab completion
set wildmenu
set wildmode=longest:full

set backup

" By default, Vim only remembers the last 20 commands, search patterns, and undos
set history=1000

" Persistent undo
set undofile            " So is persistent undo ...
set undolevels=1000     " Maximum number of changes that can be undone
set undoreload=10000    " Maximum number lines to save for undo on a buffer reload

" Highlight the line the cursor is on
set cursorline

" Don't update the screen when executing macros
set lazyredraw

" I am almost always running vim locally, so crank those buffer sizes up
set ttyfast

" Change <Leader> from Backslash to Space. By default Space is mapped to 'l' or <Right>,
" which is behavior I don't mind overriding because I always use 'l'
let mapleader = " "

silent function! OSX()
    return has('macunix')
endfunction
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction

function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory',
                \ 'undo': 'undodir' }

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory, "p")
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()

au BufRead,BufNewFile *.smali set filetype=smali 
au BufRead,BufNewFile *.as set filetype=actionscript 

" **********************
" The original

""" Split windows/multiple files
""" use <Ctrl>+s to split the current window
""nmap <C-S> <C-W>s
""" use <Ctrl>+j/<Ctrl>+k to move up/down through split windows
""nmap <C-J> <C-W>j
""nmap <C-K> <C-W>k
""" use <Ctrl>+-/<Ctrl>+= to maximise/equalise the size of split windows
""nmap <C--> <C-W>_
""nmap <C-=> <C-W>=
""" use <Ctrl>+h/<Ctrl>+l to move back/forth through files:
""nmap <C-L> :next<CR>
""nmap <C-H> :prev<CR>

if has("gui_running")
  set transparency=10
endif

set autoindent
set cindent
set smartindent
set softtabstop=4 expandtab shiftwidth=4 tabstop=4
set tw=80

" These two options, when set together, will make /-style searches
" case-sensitive only if there is a capital letter in the search expression.
" *-style searches continue to be consistently case-sensitive.
set ignorecase 
set smartcase

" When the cursor is moved outside the viewport of the current window, the
" buffer is scrolled by a single line. Setting the option below will start
" the scrolling three lines before the border, keeping more context around
" where you’re working.
set scrolloff=3

" Scroll 3 lines at a time with <C-e> and <C-y>
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Briefer messages, truncate long messages that don't fit, and no more vim intro
set shortmess=atI

" Instead of beeping, flash the screen
" set visualbell

" It's often useful to know where you are in a buffer, but full line numbering
" is distracting. Setting the option below is a good compromise:
set ruler

" Intuitive backspacing in insert mode
set backspace=indent,eol,start

set number

" Make comments readable
highlight PmenuSel ctermfg=black ctermbg=lightgray

" Make GVim pretty
" colorscheme darkblue
" set guifont=Menlo:h10
" set guioptions-=T
" set noantialias
" Disable error bells
"set vb t_vb=

"0 Insert single char (repeatable)
function! RepeatChar(char, count)
    return repeat(a:char, a:count)
endfunction
" Before selection, like insert
" 0After selection, like append
nnoremap <silent> <leader>i :<C-U>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<CR>
nnoremap <silent> <leader>a :<C-U>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<CR>

" Press <F11> to run current file if it has a shebang
function! <SID>CallInterpreter()
    if match(getline(1), '^\#!') == 0
        let l:interpreter = getline(1)[2:]
        exec ("!".l:interpreter." %:p")
    else
        echohl ErrorMsg | echo "Err: No shebang present in file, canceling execution" | echohl None
    endif
endfun
map <F11> :call <SID>CallInterpreter()<CR>

set incsearch
set nohls
nmap <leader>h :setlocal hls!<CR>:echo "Highlight Search: " . strpart("OffOn", 3 * &hls, 3)<CR>

set nopaste
nmap <leader>p :setlocal paste!<CR><Bar>:echo "Paste: " . strpart("OffOn", 3 * &paste, 3)<CR>

set listchars=tab:>-,trail:·,eol:$
nmap <leader>e :set nolist!<CR><Bar>:echo "Show Trailig: " . strpart("OffOn", 3 * &list, 3)<CR>

" Disable arrow keys
" noremap  <Up> ""
" noremap! <Up> <Esc>
" noremap  <Down> ""
" noremap! <Down> <Esc>
" noremap  <Left> ""
" noremap! <Left> <Esc>
" noremap  <Right> ""
" noremap! <Right> <Esc>

autocmd FileType javascript set softtabstop=4 shiftwidth=4 tabstop=4

autocmd FileType tex set nocindent

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
" filetype plugin on
"
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on
filetype on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" switch on syntax highlighting
syntax enable
set background=dark

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'component': {
      \   'readonly': '%{&readonly? "" :""}',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ }
set laststatus=2

let g:haddock_browser = "/usr/bin/chromium-browser"
let g:haddock_browser_callformat = "%U"
let g:haddock_docdir = "/usr/share/doc/ghc6-doc"

"let g:haddock_indexfiledir = "
noremap <silent><a-k> :call feedkeys( line('.')==1 ? '' : 'ddkP' )<CR>
noremap <silent><a-j>  ddp

imap jk <Esc>
noremap L :<C-U>tabnext<CR>
noremap H :<C-U>tabprevious<CR>

