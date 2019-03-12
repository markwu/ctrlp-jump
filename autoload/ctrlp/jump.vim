if exists('g:loaded_ctrlp_jump') && g:loaded_ctrlp_jump
    finish
endif
let g:loaded_ctrlp_jump = 1

let s:jump_var = {
            \  'init':   'ctrlp#jump#init()',
            \  'exit':   'ctrlp#jump#exit()',
            \  'accept': 'ctrlp#jump#accept',
            \  'lname':  'jump',
            \  'sname':  'jump',
            \  'type':   'jump',
            \  'sort':   0,
            \}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
    let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:jump_var)
else
    let g:ctrlp_ext_vars = [s:jump_var]
endif

if exists("g:ctrlp_jump_jumps")
    unlet g:ctrlp_jump_jumps
endif

function! ctrlp#jump#get_jumps()
    let s = ''
    redir => s
    silent jumps
    redir END

    let g:ctrlp_jump_jumps = sort(split(s, "\n"))
endfunction

function! ctrlp#jump#command()
    call ctrlp#jump#get_jumps()
    call ctrlp#init(ctrlp#jump#id())
endfunction

function! ctrlp#jump#init()
    call ctrlp#jump#get_jumps()
    return g:ctrlp_jump_jumps
endfunction

function! ctrlp#jump#accept(mode, str)
    call ctrlp#exit()

    let elements = matchlist(a:str, '\v^(.)\s*(\d+)\s+(\d+)\s+(\d+)\s*(.*)$')

    if empty(elements)
        return
    endif

    call ctrlp#acceptfile(a:mode, elements[5])
    call cursor(elements[3], elements[4])
endfunction

function! ctrlp#jump#exit()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#jump#id()
    return s:id
endfunction
