
function! helpeek#help#find(target) abort
    let help_path = fnamemodify(&helpfile, ':h') . '/tags'
    let paths = [help_path]
    call extend(paths, globpath(&runtimepath, 'doc/tags', v:true, v:true))

    for path in paths
        if !filereadable(path)
            continue
        endif
        for line in readfile(path)
            let tag = split(line, "\t")[0]
            if count(tag, a:target) != 0
                return s:new(tag)
            endif
        endfor
    endfor

    return v:null
endfunction

function! s:new(tag) abort
    let help = {
        \ '_tag': a:tag,
    \ }

    function! help.buffer() abort
        execute 'help' self._tag
        let bufnr = bufnr('%')
        quit
        return bufnr
    endfunction

    return help
endfunction
