function! airline#extensions#tabline#formatters#uniq_tail_or_proj#format(bufnr, buffers)
  let projName = getbufvar(a:bufnr, 'title')  " From vim-project
  if empty(projName)
    return airline#extensions#tabline#formatters#unique_tail_improved#format(a:bufnr, a:buffers)
  else
    return projName . (getbufvar(a:bufnr, '&modified') ? g:airline_symbols.modified : '')
  endif
endfunction
