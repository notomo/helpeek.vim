
function! helpeek#messenger#clear() abort
    let f = {}
    function! f.default(message) abort
        echomsg a:message
    endfunction

    let s:func = { message -> f.default(message) }
endfunction

call helpeek#messenger#clear()


function! helpeek#messenger#set_func(func) abort
    let s:func = { message -> a:func(message) }
endfunction

function! helpeek#messenger#new() abort
    let messenger = {
        \ 'func': s:func,
    \ }

    function! messenger.warn(message) abort
        echohl WarningMsg
        call self.func('[helpeek] ' . a:message)
        echohl None
    endfunction

    return messenger
endfunction
