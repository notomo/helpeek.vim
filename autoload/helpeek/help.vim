
function! helpeek#help#find(target) abort
    let logger = helpeek#logger#new('help')
    call logger.log('try to find: ' . a:target)

    let help_path = fnamemodify(&helpfile, ':h') . '/tags'
    let paths = [help_path]
    call extend(paths, globpath(&runtimepath, 'doc/tags', v:true, v:true))

    let found_tags = []
    for path in paths
        if !filereadable(path)
            continue
        endif
        for line in readfile(path)
            let tag = split(line, "\t")[0]
            if count(tag, a:target) != 0
                call logger.log('found tag: ' . tag)
                call add(found_tags, tag)
            endif
        endfor
    endfor
    if !empty(found_tags)
        call sort(found_tags, {a, b -> strlen(a) > strlen(b) })
        call logger.log('found and matched tag: ' . found_tags[0])
        return s:new(found_tags[0])
    endif

    return v:null
endfunction

function! s:new(tag) abort
    let help = {
        \ '_tag': a:tag,
    \ }

    function! help.buffer() abort
        execute 'help' self._tag
        let bufnr = bufnr('%')
        let line = line('.') + 1
        call setpos('.', [bufnr, line, 1, 0])
        quit
        return [bufnr, line]
    endfunction

    return help
endfunction
