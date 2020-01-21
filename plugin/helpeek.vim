if exists('g:loaded_helpeek')
    finish
endif
let g:loaded_helpeek = 1

"" Show a help buffer from current context.
" ```
" :Helpeek " opens the cursor position help
" :Helpeek count() " opens count() help
" ```
command! -nargs=? Helpeek call helpeek#main(<q-args>)

"" window border highlight group
highlight default link HelpeekBorder StatusLine
