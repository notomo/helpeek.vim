
function! helpeek#target#get() abort
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
