" Spaces/Tabs
set shiftwidth=4
set tabstop=4
set expandtab
set softtabstop=4

" Backups
set nobackup
set nowritebackup
set noswapfile

" Keybindings
nm , :
let mapleader = ";"

" Search
set showmatch
set incsearch

" Syntax and indentation
syntax on
filetype plugin on
filetype indent on

autocmd FileType html,html.* setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript,javascript.* setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css,css.* setlocal shiftwidth=2 tabstop=2 softtabstop=2

" Appearance
set laststatus=2
set listchars=eol:¶
set list
hi NonText ctermfg=0

set nowrap
