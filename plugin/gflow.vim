scriptencoding utf-8

if exists(':Git')
  if exists('g:loaded_gflow')
    finish
  endif

  let g:loaded_gflow = 1

  let s:cpo_save = &cpo
  set cpo&vim

  command! -nargs=* -complete=custom,gflow#complete Gflow Git flow <args>

  command! -nargs=* -complete=custom,gflow#feature_complete FFstart Git flow feature start <args>
  command! -nargs=* -complete=custom,gflow#feature_complete FFfinish Git flow feature finish <args>
  command! -nargs=* -complete=custom,gflow#feature_complete FFdelete Git flow feature delete <args>
  command! -nargs=* -complete=custom,gflow#feature_complete FFpublish Git flow feature publish <args>
  command! -nargs=* -complete=custom,gflow#feature_complete FFtrack Git flow feature track <args>

  command! -nargs=* -complete=custom,gflow#release_complete FRstart Git flow release start <args>
  command! -nargs=* -complete=custom,gflow#release_complete FRfinish Git flow release finish <args>
  command! -nargs=* -complete=custom,gflow#release_complete FRdelete Git flow release delete <args>
  command! -nargs=* -complete=custom,gflow#release_complete FRpublish Git flow release publish <args>
  command! -nargs=* -complete=custom,gflow#release_complete FRtrack Git flow release track <args>

  command! -nargs=* -complete=custom,gflow#hotfix_complete FHstart Git flow hotfix start <args>
  command! -nargs=* -complete=custom,gflow#hotfix_complete FHfinish Git flow hotfix finish <args>
  command! -nargs=* -complete=custom,gflow#hotfix_complete FHdelete Git flow hotfix delete <args>
  command! -nargs=* -complete=custom,gflow#hotfix_complete FHpublish Git flow hotfix publish <args>

  let &cpo = s:cpo_save

  unlet s:cpo_save
endif
