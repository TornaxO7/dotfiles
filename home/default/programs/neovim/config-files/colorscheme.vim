if $TERM == 'linux'
    set background=dark
else
    highlight LspDiagnosticsVirtualTextError guifg=Red guibg=#eee8d5
    highlight Visual cterm=reverse ctermbg=NONE
    highlight Normal guibg=white
endif
