" bdubs.vim - quickly delete and wipeout buffers
" Author: Josh Branchaud (joshbranchaud.com)
" Version: 0.1


if exists('g:loaded_bdubs')
  finish
endif
let g:loaded_bdubs = 1

let s:save_cpo = &cpo
set cpo&vim

function! s:AllBuffersByNumber()
  let last_buffer = bufnr("$")
  let existing_buffers = filter(range(1, last_buffer), 'bufexists(v:val)')
  return existing_buffers
endfunction

function! s:DeleteBuffers(args)
  let current_buffer = bufnr("%")
  for buffer_number in AllBuffersByNumber()
    if current_buffer != buffer_number
      execute buffer_number.'bd'
    endif
  endfor
endfunction

function! s:WipeoutBuffers(args)
  let current_buffer = bufnr("%")
  for buffer_number in AllBuffersByNumber()
    if current_buffer != buffer_number
      execute buffer_number.'bw'
    endif
  endfor
endfunction

command! -nargs=* BD call s:DeleteBuffers( '<args>' )
command! -nargs=* BW call s:WipeoutBuffers( '<args>' )

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set sw=2 sts=2:
