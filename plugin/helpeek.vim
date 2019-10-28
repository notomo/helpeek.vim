if exists('g:loaded_helpeek')
    finish
endif
let g:loaded_helpeek = 1

"" Show a help buffer from current context.
command! Helpeek call helpeek#main()
