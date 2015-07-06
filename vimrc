" Voy a empezar a usar Vim en la terminal, asi que me gustaría activar los
" 256 colores
set t_Co=256

" Configuración para Vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'hallison/vim-markdown'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/powerline'
Plugin 'tyru/current-func-info.vim'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-notes'

call vundle#end()
filetype plugin indent on

" Me gusta usar espacios, no tabulación
set shiftwidth=4
set tabstop=4
set expandtab
set softtabstop=4

" Prefiero no tener backups
set nobackup
set nowritebackup
set noswapfile

" Cuando usas autocompletación de archivos, que arriba te muestre un listado
" de las posibles ocurrencias
set wildmode=longest,full
set wildmenu

syntax on

set nowrap
set autoindent

" Por defecto usamos el clipboard de Ubuntu
set clipboard=unnamedplus

" APARIENCIA

" Siempre mostrar la barra de estado
set laststatus=2

" Contenido de la barra de estado
" set statusline=%03.3l,%03.3v\ •\ %f\ %m%=%{fugitive#statusline()}
set showmatch
set incsearch

" En algún lugar vi esto, y me pareció bueno ponerlo :P, te muestra los
" fines de linea y los espacios extras al final de las lineas
" set listchars=eol:¶,trail:•,tab:××
set listchars=eol:¶
set list

" Es más conveniente para no tener que estar apretando Shift
nm , :

" El mapleader es ;
let mapleader = ";"

hi phpSyntaxError ctermbg=1 ctermfg=255
fun! CheckPHPSyntax()
    let error = substitute(system("php -l " . expand("%") .  " 2>&1 | sed 's/.*\ //g' | head -n 1 | grep '^[0-9]\\+$'"), "\n", "", "")
    if error
        hi StatusLine ctermfg=1 ctermbg=255
        exe "match phpSyntaxError /\\%" . error . "l/"
        exe "normal" error . "gg"
    else
        hi StatusLine ctermfg=None ctermbg=None
        match None
    endif
endfunction
au! BufWritePost *.php call CheckPHPSyntax()

hi NonText ctermfg=7

hi ExtraWhitespace ctermbg=1
au! BufWinEnter * match ExtraWhitespace /\s\+$/
au! BufEnter * match ExtraWhitespace /\s\+$/
au! WinEnter * match ExtraWhitespace /\s\+$/

" Activando powerline
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

" Habilitar la configuración por proyecto
set exrc
set secure

nm <leader>nt :exe 'Note ' . strftime('%Y-%m-%d')<CR>
nm <leader>nw :exe 'Note ' . strftime('%Y-W%V')<CR>
