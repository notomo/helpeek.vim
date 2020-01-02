
let s:suite = themis#suite('plugin.helpeek')
let s:assert = HelpeekTestAssert()

function! s:suite.before_each()
    call HelpeekTestBeforeEach(s:assert)
endfunction

function! s:suite.after_each()
    call HelpeekTestAfterEach()
endfunction

function! s:suite.nvim_normal()
    call setbufline('%', 1, 'call')

    Helpeek

    wincmd w
    call s:assert.window_count(3)
    call s:assert.filetype('help')
    call s:assert.contains_line('*:call*', line('.') - 1)
    call s:assert.column_number(1)

    wincmd p
    call s:assert.window_count(3)
endfunction

function! s:suite.nvim_normal_with_empty()
    Helpeek

    call s:assert.window_count(1)
endfunction

function! s:suite.nvim_close_with_border()
    call setbufline('%', 1, 'call')

    Helpeek

    wincmd w
    call s:assert.window_count(3)

    quit
    call s:assert.window_count(1)

    call s:assert.not_exists_autocmd('helpeek')
endfunction

function! s:suite.nvim_function_help()
    edit ./test/_data/test.vim
    normal! w

    Helpeek

    call s:assert.window_count(3)

    wincmd w
    call s:assert.contains_line('*count()*', line('.') - 1)
endfunction

function! s:suite.nvim_map_mod_help()
    edit ./test/_data/test.vim
    normal! jw

    Helpeek

    call s:assert.window_count(3)

    wincmd w
    call s:assert.contains_line('*:map-<buffer>*', line('.') - 1)
endfunction

function! s:suite.vim_normal()
    call setbufline('%', 1, 'call')

    Helpeek

    let popup = s:assert.popup(3, &columns - 4)
    call s:assert.buffer_filetype(popup.bufnr, 'help')
    let line_number = popup_getpos(popup.window).firstline - 1
    call s:assert.buffer_contains_line(popup.bufnr, '*:call*', line_number)
endfunction

function! s:suite.vim_normal_with_empty()
    Helpeek

    call s:assert.not_exists_popup(3, &columns - 4)
endfunction

function! s:suite.vim_function_help()
    edit ./test/_data/test.vim
    normal! w

    Helpeek

    let popup = s:assert.popup(3, &columns - 4)
    call s:assert.buffer_filetype(popup.bufnr, 'help')
    let line_number = popup_getpos(popup.window).firstline - 1
    call s:assert.buffer_contains_line(popup.bufnr, '*count()*', line_number)
endfunction

function! s:suite.vim_map_mod_help()
    edit ./test/_data/test.vim
    normal! jw

    Helpeek

    let popup = s:assert.popup(3, &columns - 4)
    call s:assert.buffer_filetype(popup.bufnr, 'help')
    let line_number = popup_getpos(popup.window).firstline - 1
    call s:assert.buffer_contains_line(popup.bufnr, '*:map-<buffer>*', line_number)
endfunction

if has('nvim')
    call filter(s:suite, { name -> name !~# '^vim_' })
else
    call filter(s:suite, { name -> name !~# '^nvim_' })
endif
