
function! helpeek#window#new() abort
    let window = {
        \ '_width': 86,
        \ '_height': &lines / 2,
        \ '_row': 3,
        \ '_col': &columns - 2,
        \ '_row_border': 1,
        \ '_col_border': 2,
        \ '_window': v:null,
        \ '_border_window': v:null,
        \ '_border_bufnr': v:null,
    \ }

    function! window.open(bufnr) abort
        let self._window = nvim_open_win(a:bufnr, v:false, {
            \ 'relative': 'editor',
            \ 'width': self._width - self._col_border * 2,
            \ 'height': self._height - self._row_border * 2,
            \ 'row': self._row,
            \ 'col': self._col - self._col_border,
            \ 'anchor': 'NE',
            \ 'focusable': v:true,
            \ 'external': v:false,
            \ 'style': 'minimal',
        \ })
        call nvim_win_set_var(self._window, '&sidescrolloff', 0)

        let self._border_bufnr = nvim_create_buf(v:false, v:true)
        let self._border_window = nvim_open_win(self._border_bufnr, v:false, {
            \ 'relative': 'editor',
            \ 'width': self._width,
            \ 'height': self._height,
            \ 'row': self._row - self._row_border,
            \ 'col': self._col,
            \ 'anchor': 'NE',
            \ 'focusable': v:false,
            \ 'external': v:false,
            \ 'style': 'minimal',
        \ })
        call nvim_win_set_option(self._border_window, 'winhighlight', 'Normal:StatusLine')
        call nvim_buf_set_option(self._border_bufnr, 'bufhidden', 'wipe')
    endfunction

    function! window.close() abort
        if !empty(self._window) && nvim_win_is_valid(self._window)
            call nvim_win_close(self._window, v:false)
        endif
        if !empty(self._border_window) && nvim_win_is_valid(self._border_window)
            call nvim_win_close(self._border_window, v:false)
        endif
    endfunction

    return window
endfunction
