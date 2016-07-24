if exists('g:loaded_search_helpers')
    finish
endif

function! s:GetSelectedText() range
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
        return ""
    else
        return selection
    endif
endfunction

function! GetSelectedTextForSubstitute() range
    let selection = s:GetSelectedText()

    " Escape regex characters
    let escaped_selection = escape(selection, '^$.*\/~[]')

    " Escape the line endings
    let escaped_selection = substitute(escaped_selection, '\n', '\\n', 'g')

    return escaped_selection
endfunction

function! GetSelectedTextForSearch() range
    let selection = s:GetSelectedText()

    " Escape some characters
    let escaped_selection = escape(selection, '"%#*$')

    if empty(escaped_selection)
        return ""
    else
        return '"' . escaped_selection . '"'
    endif
endfunction

function! GetSelectedTextForGrepper() range
    let selection = s:GetSelectedText()

    " Escape some characters
    let escaped_selection = escape(selection, "'%#*$")

    if empty(escaped_selection)
        return ""
    else
        return "'" . escaped_selection . "'"
    endif
endfunction

function! GetWordForSearch() range
    let cword = expand("<cword>")

    if empty(cword)
        return ""
    else
        return shellescape(fnameescape(cword))
    endif
endfunction

function! GetWordForSubstitute()
    let cword = expand("<cword>")

    if empty(cword)
        return ""
    else
        return cword . '/'
    endif
endfunction

let g:loaded_search_helpers = '0.4.0'
