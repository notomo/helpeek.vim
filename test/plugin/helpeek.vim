
let s:helper = HelpeekTestHelper()
let s:suite = s:helper.suite('plugin.helpeek')
let s:assert = s:helper.assert

function! s:suite.builtin_command_help()
    call s:helper.create_buffer('call hoge()')
    call s:helper.search('call')

    Helpeek

    call s:assert.opened_help_tag(':call')
    call s:assert.column_number(1)
endfunction

function! s:suite.user_command_help()
    call s:helper.create_buffer('Helpeek')
    call s:helper.search('Helpeek')

    Helpeek

    call s:assert.opened_help_tag(':Helpeek')
endfunction

function! s:suite.builtin_function_help()
    call s:helper.create_buffer('call count([])')
    call s:helper.search('count')

    Helpeek

    call s:assert.opened_help_tag('count()')
endfunction

function! s:suite.map_mod_help()
    call s:helper.create_buffer('nnoremap <buffer> F :<C-u>echomsg "test"<CR>')
    call s:helper.search('buffer')

    Helpeek

    call s:assert.opened_help_tag(':map-<buffer>')
endfunction

function! s:suite.var_help()
    call s:helper.create_buffer("let g:mapleader = ','")
    call s:helper.search('mapleader')

    Helpeek

    call s:assert.opened_help_tag('mapleader')
endfunction

function! s:suite.autoload_function_help()
    call s:helper.create_buffer('call gnat#New()')
    call s:helper.search('gnat')

    Helpeek

    call s:assert.opened_help_tag('gnat#New()')
endfunction

function! s:suite.highlight_group_help()
    call s:helper.create_buffer('echohl ErrorMsg')
    call s:helper.search('ErrorMsg')

    Helpeek

    call s:assert.opened_help_tag('hl-ErrorMsg')
endfunction

function! s:suite.backword_match_function_name_help()
    call s:helper.create_buffer('call search()')
    call s:helper.search('search')

    Helpeek

    call s:assert.opened_help_tag('search()')
endfunction


function! s:suite.with_arg()
    Helpeek count()

    call s:assert.opened_help_tag('count()')
endfunction


function! s:suite.nvim_normal_with_empty()
    Helpeek

    call s:assert.window_count(1)
endfunction

function! s:suite.vim_normal_with_empty()
    Helpeek

    call s:assert.not_exists_popup()
endfunction

function! s:suite.nvim_close_with_border()
    call s:helper.create_buffer('call hoge()')

    Helpeek

    call s:assert.window_count(3)
    wincmd w

    " goto other help file
    call s:helper.search('|gO|')
    execute "normal! \<C-]>"

    call s:helper.autocmds_log()

    quit
    call s:assert.window_count(1)

    call s:assert.not_exists_autocmd('helpeek')
endfunction

if has('nvim')
    call filter(s:suite, { name -> name !~# '^vim_' })
else
    call filter(s:suite, { name -> name !~# '^nvim_' })
endif
