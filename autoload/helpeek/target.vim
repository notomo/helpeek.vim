
function! helpeek#target#get() abort
    if mode() ==# 'c'
        let line = getcmdline()
    else
        let cword = expand('<cword>')
        let syntax_name = synIDattr(synID(line('.'), col('.'), v:true), 'name')
        if syntax_name ==? 'vimFuncName'
            return cword . '()'
        elseif syntax_name ==? 'vimOption'
            return printf("'%s'", cword)
        elseif syntax_name ==? 'vimCommand'
            return ':' . cword
        else
            let line = cword
        endif
    endif
    if empty(line)
        return ''
    endif

    let factors = split(line, '\v\s')
    if len(factors) == 1
        return ':' . factors[0]
    endif

    return factors[-1]
endfunction
