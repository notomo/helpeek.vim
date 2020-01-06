
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
        elseif syntax_name ==? 'vimMapModKey' || syntax_name ==? 'vimMapMod'
            return printf(':map-<%s>', cword)
        elseif syntax_name ==? 'vimVar'
            return substitute(expand('<cWORD>'), '\v^g:', '', '')
        elseif syntax_name ==? 'vimIsCommand'
            " HACK: for autoload function
            let func_name = substitute(expand('<cWORD>'), '\v\(.*', '', '')
            return func_name . '()'
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
