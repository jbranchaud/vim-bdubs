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

function! s:BufferIsRemoveable(buffer_number, bang)
  return a:bang == '!' || !getbufvar(a:buffer_number, "&mod")
endfunction

function! s:DeleteBuffers(args, bang)
  let current_buffer = bufnr("%")
  for buffer_number in AllBuffersByNumber()
    if current_buffer != buffer_number && s:BufferIsRemoveable(buffer_number, a:bang)
      execute buffer_number.'bd'.a:bang
    endif
  endfor
  echomsg "buffers deleted"
endfunction

function! s:WipeoutBuffers(args, bang)
  let current_buffer = bufnr("%")
  for buffer_number in AllBuffersByNumber()
    if current_buffer != buffer_number && s:BufferIsRemoveable(buffer_number, a:bang)
      execute buffer_number.'bw'.a:bang
    endif
  endfor
  echomsg "buffers wiped out"
endfunction

command! -nargs=* -bang BD call s:DeleteBuffers( '<args>', '<bang>' )
command! -nargs=* -bang BW call s:WipeoutBuffers( '<args>', '<bang>' )

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set sw=2 sts=2:
