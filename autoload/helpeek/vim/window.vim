
function! helpeek#vim#window#new(width, height, row, col) abort
    let window = {
        \ '_window': v:null,
        \ '_row': a:row,
        \ '_col': a:col,
        \ '_width': a:width,
        \ '_height': a:height,
    \ }

    function! window.open(bufnr, line) abort
        let self._window = popup_create(a:bufnr, {
            \ 'line': self._row,
            \ 'col': self._col,
            \ 'pos': 'topright',
            \ 'border': [1, 2, 1, 2],
            \ 'borderhighlight': ['StatusLine'],
            \ 'maxheight': self._height,
            \ 'maxwidth': self._width,
            \ 'firstline': a:line,
            \ 'drag': v:true,
            \ 'scrollbar': v:false,
        \ })
    endfunction

    function! window.close() abort
        call popup_close(self._window)
    endfunction

    return window
endfunction
