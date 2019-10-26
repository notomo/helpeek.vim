
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
        \ 'logger': helpeek#logger#new('window'),
    \ }

    function! window.open(bufnr) abort
        let event_service = helpeek#event#service()
        call self.logger.log('parent window: ' . win_getid())

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
        call nvim_buf_set_option(a:bufnr, 'bufhidden', 'wipe')
        call nvim_win_set_var(self._window, '&sidescrolloff', 0)
        call event_service.on_buffer_wiped(self._window, a:bufnr, { window_id -> self.close() })
        call self.logger.log('window: ' . self._window)

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
        call event_service.on_buffer_wiped(self._border_window, self._border_bufnr, { window_id -> self.close() })
        call self.logger.log('border window: ' . self._border_window)
    endfunction

    function! window.close() abort
        if !empty(self._window) && nvim_win_is_valid(self._window)
            call nvim_win_close(self._window, v:true)
            call self.logger.log('close window: ' . self._window)
        endif
        if !empty(self._border_window) && nvim_win_is_valid(self._border_window)
            call nvim_win_close(self._border_window, v:true)
            call self.logger.log('close border window: ' . self._border_window)
        endif
    endfunction

    return window
endfunction
