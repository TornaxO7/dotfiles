noremap <2-RightMouse> zO

tnoremap <silent> <Esc> <C-\><C-n>

noremap w <C-w>

if &readonly || &buftype == 'nofile'
    augroup QuitMappings
        autocmd!
        autocmd BufEnter <silent><buffer> nnoremap q :q<CR>
    augroup END
else
    noremap <silent> q :wq<CR>
endif

nnoremap ö q

onoremap <C-l> <Esc>
xnoremap <C-l> <Esc>
inoremap <C-l> <Esc>
