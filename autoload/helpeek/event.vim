
let s:WINDOW_CLOSED = 'HelpeekWindowClosed'

let s:callbacks = {}

function! helpeek#event#service() abort
    let service = {
        \ 'logger': helpeek#logger#new('event'),
    \ }

    function! service.on_window_closed(window_id, bufnr, callback) abort
        execute printf('autocmd WinClosed <buffer=%s> ++nested call helpeek#event#service().window_closed(%s, %s)', a:bufnr, a:bufnr, a:window_id)
        let event_name = s:buffer_event_name(s:WINDOW_CLOSED, a:bufnr)

        execute 'augroup' event_name
            call self._on_event(event_name, a:window_id, a:bufnr, a:callback)
        execute 'augroup END'

        execute printf('autocmd WinClosed <buffer=%s> ++nested call s:clean("%s")', a:bufnr, event_name)
        execute printf('autocmd BufWipeout <buffer=%s> ++nested call s:clean("%s")', a:bufnr, event_name)
    endfunction

    function! service._on_event(event_name, id, bufnr, callback) abort
        let s:callbacks[a:event_name] = a:callback
        let event = a:event_name . ':' . a:id
        execute printf('autocmd User %s ++nested call s:callback(expand("<amatch>"), "%s", %s)', event, a:event_name, a:bufnr)
    endfunction

    function! service.window_closed(bufnr, window_id) abort
        let event_name = s:buffer_event_name(s:WINDOW_CLOSED, a:bufnr)
        let event = printf('%s:%s', event_name, a:window_id)
        execute printf('doautocmd User %s', event)
    endfunction

    return service
endfunction

function! s:buffer_event_name(event_name, bufnr) abort
    return a:event_name . '_' . a:bufnr
endfunction

function! s:callback(amatch, event_name, bufnr) abort
    let [_, id] = split(a:amatch, a:event_name . ':', 'keep')
    if has_key(s:callbacks, a:event_name)
        call s:callbacks[a:event_name](id)
    endif
endfunction

function! s:clean(event_name) abort
    if !has_key(s:callbacks, a:event_name)
        return
    endif
    execute 'autocmd!' . a:event_name
    call remove(s:callbacks, a:event_name)
endfunction
