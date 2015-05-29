set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4     " a hard TAB displays as 4 columns
set expandtab     " insert spaces when hitting TABs
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line
set hlsearch      " highlighting search matches

set background=dark " set the color of the font for dark backgroud
set hidden
set colorcolumn=80 " display a line at the 81th colummn
set number " display the line number
set mouse=a " when mouse click select the clicked vsp
nmap <leader>c :bprevious<CR>:bdelete #<CR>
nmap <C-Down> :bn<CR>
nmap <C-UP> :bp<CR>
"nmap <C-Right> :wincmd l<CR>
"nmap <C-Left> :wincmd h<CR>
imap <C-Space> <C-n>
set tags=tags,../tags,../../tags,../../../tags

" Add TagList plugin
filetype plugin on
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

" With this vim uses the system clipboard
set clipboard=unnamedplus
