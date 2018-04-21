if exists('g:loaded_search_helpers')
    finish
endif

function! GetSelectedText() range abort
    " Save the current register and clipboard
    let reg_save     = getreg('"')
    let regtype_save = getregtype('"')
    let cb_save      = &clipboard
    set clipboard&

    " Put the current visual selection in the " register
    normal! ""gvy

    let selection = getreg('"')

    " Put the saved registers and clipboards back
    call setreg('"', reg_save, regtype_save)
    let &clipboard = cb_save

    if selection ==# "\n"
        return ''
    else
        return selection
    endif
endfunction

function! GetSelectedTextForSubstitute() range abort
    let selection = GetSelectedText()

    " Escape regex characters
    let escaped_selection = escape(selection, '^$.*\/~[]')

    " Escape the line endings
    let escaped_selection = substitute(escaped_selection, '\n', '\\n', 'g')

    return escaped_selection
endfunction

function! GetSelectedTextForAg() range abort
    let selection = GetSelectedText()

    if empty(selection)
        return ''
    endif

    " Escape some characters
    let escaped_selection = escape(selection, '\^$.*+?()[]{}|')
    return shellescape(escaped_selection)
endfunction

function! GetSelectedTextForGrepper() range abort
    let selection = GetSelectedText()

    if empty(selection)
        return ''
    endif

    " Escape some characters
    let escaped_selection = escape(selection, '\^$.*+?()[]{}|')
    return shellescape(escaped_selection)
endfunction

function! GetSearchTextForCtrlSF() range abort
    let selection = @/

    if selection ==# "\n" || empty(selection)
        return ''
    endif

    " Escape some characters
    let escaped_selection = escape(selection, '"%#*$')
    return '"' . escaped_selection . '"'
endfunction

function! GetWordForSubstitute() abort
    let cword = expand("<cword>")

    if empty(cword)
        return ''
    else
        return cword . '/'
    endif
endfunction

let g:loaded_search_helpers = '0.9.0'
