
function! s:InTmuxSession()
	return $TMUX != ''
endfunction

function! s:TmuxBufferName()
	let l:list = systemlist('tmux list-buffers -F"#{buffer_name}"')
	if len(l:list)==0
		return ""
	else
		return l:list[0]
	endif
endfunction

function! s:TmuxBuffer()
	return system('tmux show-buffer')
endfunction

function! s:Enable()

	if has('nvim')==0
		return
	endif

	if s:InTmuxSession()==0
		return
	endif

	let g:vimtmuxclipboard_LastBufferName=""

	" @"
	augroup vimtmuxclipboard
		autocmd!
		autocmd FocusLost * let g:vimtmuxclipboard_LastBufferName = s:TmuxBufferName()
		autocmd	FocusGained   * if g:vimtmuxclipboard_LastBufferName!=s:TmuxBufferName() | let @" = s:TmuxBuffer() | endif
		autocmd TextYankPost * call s:YankPost()
	augroup END

endfunction

function! s:YankPost()
	let l:s=join(v:event["regcontents"],"\n") 
	let l:s=shellescape(l:s)
	if len(l:s)<4096
		" workaround for this bug
		if shellescape("\n")=="'\\\n'"
			let l:s=substitute(l:s,'\\\n',"\n","g")
		endif
		silent! call system('tmux set-buffer ' . l:s)
	endif
endfunction

call s:Enable()
