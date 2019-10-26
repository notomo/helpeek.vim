
let s:window = helpeek#window#new()

function! helpeek#main() abort
    let target = helpeek#target#get()
    if empty(target)
        return
    endif

    let help = helpeek#help#find(target)
    if empty(help)
        return
    endif

    call s:window.close()

    let bufnr = help.buffer()
    call s:window.open(bufnr)

    redraw
endfunction
