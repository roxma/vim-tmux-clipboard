
func! s:TmuxBufferName()
    let l:list = systemlist('tmux list-buffers -F"#{buffer_name}"')
    if len(l:list)==0
        return ""
    else
        return l:list[0]
    endif
endfunc

func! s:TmuxBuffer()
    return system('tmux show-buffer')
endfunc

func! s:Enable()

    if $TMUX=='' 
        " not in tmux session
        return
    endif

    let s:lastbname=""

    " if support TextYankPost
    if exists('##TextYankPost')==1
        " @"
        augroup vimtmuxclipboard
            autocmd!
            autocmd FocusLost * call s:update_from_tmux()
            autocmd	FocusGained   * call s:update_from_tmux()
            autocmd TextYankPost * silent! call system('tmux loadb -',join(v:event["regcontents"],"\n"))
        augroup END
        let @" = s:TmuxBuffer()
    else
        " vim doesn't support TextYankPost event
        " This is a workaround for vim
        augroup vimtmuxclipboard
            autocmd!
            autocmd FocusLost     *  silent! call system('tmux loadb -',@")
            autocmd	FocusGained   *  let @" = s:TmuxBuffer()
        augroup END
        let @" = s:TmuxBuffer()
    endif

endfunc

func! s:update_from_tmux()
    let buffer_name = s:TmuxBufferName()
    if s:lastbname != buffer_name
        let @" = s:TmuxBuffer()
    endif
    let s:lastbname=s:TmuxBufferName()
endfunc

call s:Enable()

" " workaround for this bug
" if shellescape("\n")=="'\\\n'"
" 	let l:s=substitute(l:s,'\\\n',"\n","g")
" 	let g:tmp_s=substitute(l:s,'\\\n',"\n","g")
" 	");
" 	let g:tmp_cmd='tmux set-buffer ' . l:s
" endif
" silent! call system('tmux loadb -',l:s)
