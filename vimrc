" Voy a empezar a usar Vim en la terminal, asi que me gustaría activar los
" 256 colores
set t_Co=256

" Configuración para Vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'hallison/vim-markdown'
Bundle 'tpope/vim-fugitive'

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

" El mapleader es ñ
let mapleader = "ñ"

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

" Estos son algunos errores comunes que hago cuando programo
iab This this
iab tihs this

" Carga el command correspondiente al template
nm ñoc :exe "e! " . substitute(expand("%:r"), "templates", "commands", "") . ".php"<cr>
nm ñot :exe "e! " . substitute(expand("%:r"), "commands", "templates", "") . ".tpl"<cr>

hi NonText ctermfg=235

hi ExtraWhitespace ctermbg=1
au! BufWinEnter * match ExtraWhitespace /\s\+$/
au! BufEnter * match ExtraWhitespace /\s\+$/
au! WinEnter * match ExtraWhitespace /\s\+$/
