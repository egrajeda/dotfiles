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
autocmd FileType javascript,javascript.*,typescript.* setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css,css.* setlocal shiftwidth=2 tabstop=2 softtabstop=2

" YouCompleteMe
let g:ycm_error_symbol = '••'
let g:ycm_warning_symbol = '••'
let g:ycm_add_preview_to_completeopt = 0
set completeopt-=preview 

map <C-N>rf :YcmCompleter FixIt<CR>
map <C-N>rr :YcmCompleter RefactorRename 

autocmd FileType typescript.* noremap <buffer> gd :YcmCompleter GoTo<CR>

" Appearance
set laststatus=2
set listchars=eol:¶
set list

set t_Co=256

let g:rehash256 = 1
colorscheme molokai

hi Normal ctermbg=233
hi NonText ctermfg=0

set nowrap

" Experimental
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'java']

