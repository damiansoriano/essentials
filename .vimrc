" vundle: https://github.com/VundleVim/Vundle.vim
set nocompatible        " Compatible mode means compatibility to venerable old
                        " vi. When you :set compatible, all the enhancements
                        " and improvements of Vi Improved are turned off.

filetype off            " Vim can detect the type of file that is edited.

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'szw/vim-ctrlspace'

Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


set hidden              " When off a buffer is unloaded when it is abandoned.
                        " When on a buffer becomes hidden when it is abandoned.

set shiftwidth=4        " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4           " a hard TAB displays as 4 columns
set expandtab           " insert spaces when hitting TABs
set softtabstop=4       " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround          " round indent to multiple of 'shiftwidth'
set autoindent          " align the new line indent with the previous line
set hlsearch            " highlighting search matches
set background=dark     " set the color of the font for dark backgroud
set colorcolumn=80      " display a line at the 81th colummn
set number              " display the line number
set mouse=a             " when mouse click select the clicked vsp
set incsearch       " set incremental search
set clipboard=unnamedplus   " with this vim uses the system clipboard

set tags=tags,../tags,../../tags,../../../tags

nmap <leader>c :bprevious<CR>:bdelete #<CR>
nmap <C-Down> :bn<CR>
nmap <C-j> :bn<CR>
nmap <C-Up> :bp<CR>
nmap <C-k> :bp<CR>
imap <C-Space> <C-n>

" Associate F12 to the pytags command
noremap <f12> :silent !pytags<cr>:FufRenewCache<cr>

" go to defn of tag under the cursor
fun! MatchCaseTag()
    let ic = &ic
    set noic
    try
        exe 'tjump ' . expand('<cword>')
    finally
       let &ic = ic
    endtry
endfun
nnoremap <silent> <c-]> :call MatchCaseTag()<CR>

" Fuzzy search
set rtp+=~/.fzf
nnoremap <C-z> :FZF<CR>
