" bdubs.vim - quickly delete and wipeout buffers
" Author: Josh Branchaud (joshbranchaud.com)
" Version: 0.1


if exists('g:loaded_bdubs')
  finish
endif
let g:loaded_bdubs = 1

let s:save_cpo = &cpo
set cpo&vim


function! s:Reject(list, reject_func)
  return filter(a:list, '!('.a:reject_func.')')
endfunction

function! s:BufferNotListed(buffer_number)
  return !buflisted(a:buffer_number)
endfunction

function! s:BufferIsCurrent(buffer_number)
  return bufnr("%") == a:buffer_number
endfunction

function! s:BufferIsModified(buffer_number)
  return getbufvar(a:buffer_number, "&mod")
endfunction

function! s:AllBuffersByNumber()
  let last_buffer = bufnr("$")
  let existing_buffers = filter(range(1, last_buffer), 'bufexists(v:val)')
  return existing_buffers
endfunction

function! s:BufferIsRemoveable(buffer_number, bang)
  return a:bang == '!' || !getbufvar(a:buffer_number, "&mod")
endfunction

function! s:BuffersToRemove(filters)
  let last_buffer = bufnr("$")
  let buffer_list = filter(range(1, last_buffer), 'bufexists(v:val)')
  for filter_func in a:filters
    let buffer_list = s:Reject(buffer_list, filter_func.'(v:val)')
  endfor
  return buffer_list
endfunction

function! s:DeleteBuffers(args, bang)
  let filters = ['s:BufferIsCurrent']
  let filters += ['s:BufferNotListed']
  if a:bang != '!'
    let filters += ['s:BufferIsModified']
  endif

  let buffer_list = s:BuffersToRemove(filters)
  let buffer_count = len(buffer_list)

  for buffer_number in buffer_list
    execute buffer_number.'bd'.a:bang
  endfor

  echomsg buffer_count." buffers deleted"
endfunction

function! s:WipeoutBuffers(args, bang)
  let filters = ['s:BufferIsCurrent']
  if a:bang != '!'
    let filters += ['s:BufferIsModified']
  endif

  let buffer_list = s:BuffersToRemove(filters)
  let buffer_count = len(buffer_list)

  for buffer_number in buffer_list
    execute buffer_number.'bw'.a:bang
  endfor

  echomsg buffer_count." buffers wiped out"
endfunction

command! -nargs=* -bang BD call s:DeleteBuffers( '<args>', '<bang>' )
command! -nargs=* -bang BW call s:WipeoutBuffers( '<args>', '<bang>' )


let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set sw=2 sts=2:
