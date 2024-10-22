
let s:window = helpeek#window#new()

function! helpeek#main(...) abort
    if !empty(getcmdwintype())
        return helpeek#messenger#new().warn('not supported cmdline-window')
    endif

    let arg = get(a:000, 0, v:null)

    let target = helpeek#target#get(arg)
    if empty(target)
        return
    endif

    let help = helpeek#help#find(target)
    if empty(help)
        return
    endif

    call s:window.close()

    let [bufnr, line] = help.buffer()
    call s:window.open(bufnr, line)

    redraw
endfunction
