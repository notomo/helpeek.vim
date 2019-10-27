
let s:suite = themis#suite('plugin.helpeek')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
    call HelpeekTestBeforeEach(s:assert)
endfunction

function! s:suite.after_each()
    call HelpeekTestAfterEach()
endfunction

function! s:suite.nvim_normal()
    let target = 'call'
    call setbufline('%', 1, target)

    Helpeek

    wincmd w
    call s:assert.window_count(3)
    call s:assert.equals(&filetype, 'help')
    call s:assert.contains_line('*:' . target . '*', line('.') - 1)
    call s:assert.equals(col('.'), 1)

    wincmd p
    call s:assert.window_count(3)
endfunction

function! s:suite.nvim_normal_with_empty()
    Helpeek

    call s:assert.window_count(1)
endfunction

function! s:suite.nvim_close_with_border()
    let target = 'call'
    call setbufline('%', 1, target)

    Helpeek

    wincmd w
    call s:assert.window_count(3)

    quit
    call s:assert.window_count(1)

    call s:assert.not_exists_autocmd('helpeek')
endfunction

function! s:suite.vim_normal()
    let target = 'call'
    call setbufline('%', 1, target)

    Helpeek

    let popup = s:assert.popup(3, &columns - 4)

    let filetype = getbufvar(popup.bufnr, '&filetype')
    call s:assert.equals(filetype, 'help')

    let line_number = popup_getpos(popup.window).firstline - 1
    let line = getbufline(popup.bufnr, line_number)[0]
    call s:assert.contains(line, '*:' . target . '*')
endfunction

function! s:suite.vim_normal_with_empty()
    Helpeek

    call s:assert.not_exists_popup(3, &columns - 4)
endfunction

if has('nvim')
    call filter(s:suite, { name -> name !~# '^vim_' })
else
    call filter(s:suite, { name -> name !~# '^nvim_' })
endif
