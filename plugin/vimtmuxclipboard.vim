
let g:vim_tmux_clipboard#loadb_option = get(g:, 'vim_tmux_clipboard#loadb_option', '')

func! s:TmuxBufferName()
    let l:list = systemlist('tmux list-buffers -F"#{buffer_name}"')
    if len(l:list)==0
        return ""
    else
        return l:list[0]
    endif
endfunc

function! s:on_stdout(job_id, data, event)
    let @" = join(a:data, "\n")
endfunction

func! s:AsyncTmuxBuffer()
    call jobstart('tmux show-buffer', {'on_stdout': function('s:on_stdout'), 'stdout_buffered': 1})
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
            autocmd	FocusGained * call s:update_from_tmux()
            autocmd TextYankPost * silent! call system('tmux loadb ' . g:vim_tmux_clipboard#loadb_option . ' -',join(v:event["regcontents"],"\n"))
        augroup END
        if exists('*jobstart')==1 " Only supported on Neovim
            call s:AsyncTmuxBuffer()
        else
            let @" = s:TmuxBuffer()
        endif
    else
        " vim doesn't support TextYankPost event
        " This is a workaround for vim
        augroup vimtmuxclipboard
            autocmd!
            autocmd FocusLost     *  silent! call system('tmux loadb ' . g:vim_tmux_clipboard#loadb_option . ' -',@")
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
" silent! call system('tmux loadb -w -',l:s)
