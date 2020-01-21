
let s:windows = {}

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

        let s:windows[self._window] = self

        let group_name = 'helpeek:' . self._window
        execute 'augroup' group_name
            execute printf('autocmd %s WinClosed * ++nested call s:close(expand("<afile>"))', group_name)
        execute 'augroup END'

        let self._border = s:add_border(self._width, self._height, self._row, self._col)
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

function! s:add_border(width, height, row, col) abort
    let window = {
        \ '_bufnr': nvim_create_buf(v:false, v:true),
        \ '_row_thickness': 1,
        \ '_col_thickness': 2,
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
        call nvim_win_set_option(self._window, 'winhighlight', 'Normal:HelpeekBorder')
        call nvim_buf_set_option(self._bufnr, 'bufhidden', 'wipe')
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

function! s:close(window_id) abort
    if !has_key(s:windows, a:window_id)
        return
    endif
    let window = s:windows[a:window_id]
    call window.close()
    call remove(s:windows, a:window_id)
    execute 'autocmd! helpeek:' . a:window_id
endfunction
