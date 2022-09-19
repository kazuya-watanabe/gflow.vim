scriptencoding utf-8

let s:flow_configs = {
      \ 'remote': 'origin',
      \ 'branch.master': 'master',
      \ 'branch.develop': 'develop',
      \ 'prefix.feature': 'feature/',
      \ 'prefix.bugfix': 'bugfix/',
      \ 'prefix.release': 'release/',
      \ 'prefix.hotfix': 'hotfix/',
      \ 'prefix.support': 'support/',
      \ }

let s:commands = {
      \ 'init': [
      \   ],
      \ 'feature': [
      \   'list',
      \   'start',
      \   'finish',
      \   'publish',
      \   'track',
      \   'diff',
      \   'rebase',
      \   'checkout',
      \   'pull',
      \   'delete',
      \   'rename',
      \   ],
      \ 'bugfix': [
      \   'list',
      \   'start',
      \   'finish',
      \   'publish',
      \   'track',
      \   'diff',
      \   'rebase',
      \   'checkout',
      \   'pull',
      \   'delete',
      \   'rename',
      \   ],
      \ 'release': [
      \   'list',
      \   'start',
      \   'finish',
      \   'branch',
      \   'publish',
      \   'track',
      \   'delete',
      \   'rebase',
      \   ],
      \ 'hotfix': [
      \   'list',
      \   'start',
      \   'finish',
      \   'publish',
      \   'delete',
      \   'rebase',
      \   'rename',
      \   ],
      \ 'support': [
      \   'list',
      \   'start',
      \   'rebase',
      \   ],
      \ 'version': [
      \   ],
      \ 'config': [
      \   'set',
      \   'base',
      \   ]
      \ }

function! s:get(value, default)
  return empty(a:value) ? a:default : a:value
endfunction

function! s:read_configs()
  if exists('*FugitiveConfigGet')
    let s:flow_configs['remote'] = s:get(
          \ FugitiveExecute('remote', 'show')['stdout'][0],
          \ s:flow_configs['remote']
          \ )
    let s:flow_configs['branch.master'] = s:get(
          \ FugitiveConfigGet('gitflow.branch.master'),
          \ s:flow_configs['branch.master']
          \ )
    let s:flow_configs['branch.develop'] = s:get(
          \ FugitiveConfigGet('gitflow.branch.develop'),
          \ s:flow_configs['branch.develop']
          \ )
    let s:flow_configs['prefix.feature'] = s:get(
          \ FugitiveConfigGet('gitflow.prefix.feature'),
          \ s:flow_configs['prefix.feature']
          \ )
    let s:flow_configs['prefix.bugfix'] = s:get(
          \ FugitiveConfigGet('gitflow.prefix.bugfix'),
          \ s:flow_configs['prefix.bugfix']
          \ )
    let s:flow_configs['prefix.release'] = s:get(
          \ FugitiveConfigGet('gitflow.prefix.release'),
          \ s:flow_configs['prefix.release']
          \ )
    let s:flow_configs['prefix.hotfix'] = s:get(
          \ FugitiveConfigGet('gitflow.prefix.hotfix'),
          \ s:flow_configs['prefix.hotfix']
          \ )
    let s:flow_configs['prefix.support'] = s:get(
          \ FugitiveConfigGet('gitflow.prefix.support'),
          \ s:flow_configs['prefix.support']
          \ )
  endif
endfunction

function! s:get_branches(command = v:false)
  let ret = []

  call s:read_configs()

  if exists('*FugitiveExecute')
    for i in FugitiveExecute('rev-parse', '--symbolic', '--branches', '--remotes')['stdout']
      let i = substitute(i, s:flow_configs['remote'] .. '/', '', '')

      if a:command == v:false
        call add(ret, i)
      else
        let prefix = s:flow_configs['prefix.' .. a:command]

        if stridx(i, prefix) == 0
          call add(ret, substitute(i, prefix, '', ''))
        endif
      endif
    endfor
  endif

  return uniq(sort(ret))
endfunction

function! gflow#feature_complete(ArgLead, CmdLine, CursorPos)
  return join(s:get_branches('feature'), "\n")
endfunction

function! gflow#bugfix_complete(ArgLead, CmdLine, CursorPos)
  return join(s:get_branches('bugfix'), "\n")
endfunction

function! gflow#release_complete(ArgLead, CmdLine, CursorPos)
  return join(s:get_branches('release'), "\n")
endfunction

function! gflow#hotfix_complete(ArgLead, CmdLine, CursorPos)
  return join(s:get_branches('hotfix'), "\n")
endfunction

function! gflow#support_complete(ArgLead, CmdLine, CursorPos)
  return join(s:get_branches('support'), "\n")
endfunction

function! s:get_command(arg)
  for i in keys(s:commands)
    if i == a:arg
      return i
    endif
  endfor

  return v:false
endfunction

function! s:get_subcommand(command, arg)
  for i in s:commands[a:command]
    if i == a:arg
      return i
    endif
  endfor

  return v:false
endfunction

function! gflow#complete(ArgLead, CmdLine, CursorPos)
  let cmdargs = split(a:CmdLine)
  let arglen = len(cmdargs)
  let command = arglen > 1 ? s:get_command(cmdargs[1]) : v:false
  let subcommand = arglen > 2 ? s:get_subcommand(command, cmdargs[2]) : v:false

  if command == v:false
    return join(sort(keys(s:commands)) + s:get_branches(), "\n")
  elseif subcommand == v:false
    return join(sort(s:commands[command]) + s:get_branches(), "\n")
  else
    return join(s:get_branches(command), "\n")
  endif
endfunction

