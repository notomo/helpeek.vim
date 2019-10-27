
if has('nvim')
    let s:func = 'helpeek#nvim#window#new'
else
    let s:func = 'helpeek#vim#window#new'
endif

function! helpeek#window#new() abort
    let window = {
        \ 'width': 80,
        \ 'height': &lines / 2,
        \ 'row': 3,
        \ 'col': &columns - 4,
    \ }

    return call(s:func, [
        \ window.width,
        \ window.height,
        \ window.row,
        \ window.col,
    \ ])
endfunction
