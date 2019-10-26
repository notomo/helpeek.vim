
function! helpeek#window#new() abort
    let window = {
        \ '_width': 80,
        \ '_window': v:null,
    \ }

    function! window.open(bufnr) abort
        let self._window = nvim_open_win(a:bufnr, v:false, {
            \ 'relative': 'editor',
            \ 'width': self._width,
            \ 'height': &lines / 3,
            \ 'row': 1,
            \ 'col': &columns - self._width,
            \ 'anchor': 'NW',
            \ 'focusable': v:true,
            \ 'external': v:false,
            \ 'style': 'minimal',
        \ })
        call nvim_win_set_option(self._window, 'winblend', 25)
        call nvim_win_set_var(self._window, '&sidescrolloff', 0)
    endfunction

    function! window.close() abort
        if empty(self._window) || !nvim_win_is_valid(self._window)
            return
        endif
        call nvim_win_close(self._window, v:false)
    endfunction

    return window
endfunction
