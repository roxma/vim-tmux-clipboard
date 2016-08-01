
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

	if s:InTmuxSession()==0
		return
	endif

	let g:vimtmuxclipboard_LastBufferName=""

	if has('nvim')==1
		" @"
		augroup vimtmuxclipboard
			autocmd!
			autocmd FocusLost * let g:vimtmuxclipboard_LastBufferName = s:TmuxBufferName()
			autocmd	FocusGained   * if g:vimtmuxclipboard_LastBufferName!=s:TmuxBufferName() | let @" = s:TmuxBuffer() | endif
			autocmd TextYankPost * call s:YankPost()
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

endfunction

function! s:YankPost()
	let l:s=join(v:event["regcontents"],"\n") 
	" let l:s=shellescape(l:s)
	" "if len(l:s)<4096
	" " workaround for this bug
	" if shellescape("\n")=="'\\\n'"
	" 	let l:s=substitute(l:s,'\\\n',"\n","g")
	" 	let g:tmp_s=substitute(l:s,'\\\n',"\n","g")
	" 	");
	" 	let g:tmp_cmd='tmux set-buffer ' . l:s
	" endif
	silent! call system('tmux loadb -',l:s)
	"endif
endfunction

call s:Enable()
