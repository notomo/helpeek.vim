
let s:window = helpeek#window#new()

function! helpeek#main() abort
    let target = s:get_target()
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

function! s:get_target() abort
    if mode() ==# 'c'
        let line = getcmdline()
    else
        let line = expand('<cword>')
    endif
    if empty(line)
        return ''
    endif

    let factors = split(line, '\v\s')
    if len(factors) == 1
        return ':' . factors[0]
    endif

    return factors[-1]
endfunction
