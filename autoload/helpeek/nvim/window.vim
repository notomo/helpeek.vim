
function! helpeek#nvim#window#new(width, height, row, col) abort
    let window = {
        \ '_width': a:width,
        \ '_height': a:height,
        \ '_row': a:row,
        \ '_col': a:col,
        \ '_window': v:null,
        \ '_border': v:null,
        \ 'logger': helpeek#logger#new('window'),
    \ }

    function! window.open(bufnr, _line) abort
        let event_service = helpeek#event#service()

        let self._window = nvim_open_win(a:bufnr, v:false, {
            \ 'relative': 'editor',
            \ 'width': self._width,
            \ 'height': self._height,
            \ 'row': self._row,
            \ 'col': self._col,
            \ 'anchor': 'NE',
            \ 'focusable': v:true,
            \ 'external': v:false,
            \ 'style': 'minimal',
        \ })
        call nvim_buf_set_option(a:bufnr, 'bufhidden', 'wipe')
        call nvim_win_set_var(self._window, '&sidescrolloff', 0)
        call event_service.on_buffer_wiped(self._window, a:bufnr, { window_id -> self.close() })

        let self._border = helpeek#nvim#window#add_border(self._width, self._height, self._row, self._col, event_service)
    endfunction

    function! window.close() abort
        if !empty(self._window) && nvim_win_is_valid(self._window)
            call nvim_win_close(self._window, v:true)
        endif
        if !empty(self._border)
            call self._border.close()
        endif
    endfunction

    return window
endfunction

function! helpeek#nvim#window#add_border(width, height, row, col, event_service) abort
    let window = {
        \ '_bufnr': nvim_create_buf(v:false, v:true),
        \ '_row_thickness': 1,
        \ '_col_thickness': 2,
        \ '_event_service': a:event_service,
        \ 'logger': helpeek#logger#new('window').label('border'),
    \ }

    function! window.open(width, height, row, col) abort
        let self._window = nvim_open_win(self._bufnr, v:false, {
            \ 'relative': 'editor',
            \ 'width': a:width + self._col_thickness * 2,
            \ 'height': a:height + self._row_thickness * 2,
            \ 'row': a:row - self._row_thickness,
            \ 'col': a:col + self._col_thickness,
            \ 'anchor': 'NE',
            \ 'focusable': v:false,
            \ 'external': v:false,
            \ 'style': 'minimal',
        \ })
        call nvim_win_set_option(self._window, 'winhighlight', 'Normal:StatusLine')
        call nvim_buf_set_option(self._bufnr, 'bufhidden', 'wipe')
        call self._event_service.on_buffer_wiped(self._window, self._bufnr, { window_id -> self.close() })
    endfunction

    function! window.close() abort
        if !nvim_win_is_valid(self._window)
            return
        endif
        call nvim_win_close(self._window, v:true)
    endfunction

    call window.open(a:width, a:height, a:row, a:col)

    return window
endfunction
