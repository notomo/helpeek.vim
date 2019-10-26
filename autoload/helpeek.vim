
let s:window = v:null

function! helpeek#main() abort
    let target = s:get_target()
    if empty(target)
        return
    endif

    let tag = s:find_tag(target)
    if empty(tag)
        return
    endif
    call s:close_if_need()

    execute 'help' tag
    let bufnr = bufnr('%')
    let line = line('.')
    quit

    let width = 80
    let s:window = nvim_open_win(bufnr, v:false, {
        \ 'relative': 'editor',
        \ 'width': width,
        \ 'height': &lines / 3,
        \ 'row': 1,
        \ 'col': &columns - width,
        \ 'anchor': 'NW',
        \ 'focusable': v:true,
        \ 'external': v:false,
        \ 'style': 'minimal',
    \ })
    call nvim_win_set_option(s:window, 'winblend', 25)
    call nvim_win_set_var(s:window, '&sidescrolloff', 0)

    redraw
endfunction

function! s:close_if_need() abort
    if empty(s:window) || !nvim_win_is_valid(s:window)
        return
    endif
    call nvim_win_close(s:window, v:false)
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
