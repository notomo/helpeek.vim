
function! helpeek#target#get(arg) abort
    if !empty(a:arg)
        return a:arg
    endif

    if mode() ==# 'c'
        let factors = split(getcmdline(), '\v\s')
        if empty(factors)
            return ''
        elseif len(factors) == 1
            return ':' . factors[0]
        endif
        return factors[-1]
    endif

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
    elseif syntax_name ==? 'vimVar' && expand('<cWORD>') =~? '&\k\+'
        return printf("'%s'", substitute(cword, '&', '', ''))
    elseif syntax_name ==? 'vimVar'
        return substitute(expand('<cWORD>'), '\v^g:', '', '')
    elseif syntax_name ==? 'vimHLGroup'
        return printf('hl-%s', cword)
    elseif syntax_name =~? 'vimUserAttrb'
        return printf(':command-%s', cword)
    elseif syntax_name =~? 'vimSyn\k\+'
        return printf(':syn-%s', cword)
    elseif syntax_name ==? 'vimIsCommand'
        " HACK: for autoload function
        let cword = expand('<cWORD>')
        let name = substitute(cword, '\v\(.*', '', '')
        return count(cword, name . '(') == 1 ? name . '()' : name
    endif

    return cword
endfunction
