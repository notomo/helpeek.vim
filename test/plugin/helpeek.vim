
let s:suite = themis#suite('plugin.helpeek')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call HelpeekTestBeforeEach(s:assert)
endfunction

function! s:suite.after_each()
    call HelpeekTestAfterEach()
endfunction

function! s:suite.normal()
    let target = 'call'
    call setbufline('%', 1, target)

    Helpeek

    wincmd w

    call s:assert.window_count(3)
    call s:assert.equals(&filetype, 'help')
    call s:assert.contains_line('*:' . target . '*')
endfunction

function! s:suite.normal_with_empty()
    Helpeek

    call s:assert.window_count(1)
endfunction
