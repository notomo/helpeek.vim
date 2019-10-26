
let s:window = helpeek#window#new()

function! helpeek#main() abort
    let target = s:get_target()
    if empty(target)
        return
    endif

    let tag = s:find_tag(target)
    if empty(tag)
        return
    endif
    call s:window.close()

    execute 'help' tag
    let bufnr = bufnr('%')
    let line = line('.')
    quit

    call s:window.open(bufnr)
    redraw
endfunction

function! s:get_target() abort
    if mode() ==# 'c'
        let line = getcmdline()
    else
        let line = expand('<cword>')
    endif
    let factors = split(line, '\v\s')

    let length = len(factors)
    if length == 0
        return ''
    elseif length == 1
        return ':' . factors[0]
    endif

    return factors[-1]
endfunction

function! s:find_tag(pattern) abort
    let help_path = fnamemodify(&helpfile, ':h') . '/tags'
    let paths = [help_path]
    call extend(paths, globpath(&runtimepath, 'doc/tags', v:true, v:true))

    for path in paths
        if !filereadable(path)
            continue
        endif
        for line in readfile(path)
            let tag = split(line, "\t")[0]
            if count(tag, a:pattern) != 0
                return tag
            endif
        endfor
    endfor

    return ''
endfunction
