if exists('g:loaded_helpeek')
    finish
endif
let g:loaded_helpeek = 1

"" Show a help buffer from current context.
" - `Helpeek` opens the cursor position help
" - `Helpeek [{arg}]` opens the argument help
command! -nargs=? Helpeek call helpeek#main(<q-args>)
