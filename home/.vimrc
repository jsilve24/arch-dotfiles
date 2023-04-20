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

" from https://www.reddit.com/r/vim/comments/112e8ne/vim_function_to_move_following_word_into/j8k0mez/
vnoremap K xgkp`[1v
vnoremap L xp`[1v
vnoremap H xhhp`[1v
vnoremap J xgjp`[1v
