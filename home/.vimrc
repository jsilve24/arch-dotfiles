" basic settings
syntax on

" setup leader
let mapleader = " "

" more familiar window commands under leader
:nmap <leader>wv <C-w>v
:nmap <leader>ws <C-w>s
:nmap <leader>wh <C-w>h
:nmap <leader>wl <C-w>l
:nmap <leader>wj <C-w>j
:nmap <leader>wk <C-w>k

" buffer bindings
:nmap <leader>bd :bd<CR>
:nmap <leader>bD :bd!<CR>

map ,d :e <C-R>=expand("%:p:h") . "/" <CR>
