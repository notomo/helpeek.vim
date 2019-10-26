if exists('g:loaded_helpeek')
    finish
endif
let g:loaded_helpeek = 1

command! Helpeek call helpeek#main()
