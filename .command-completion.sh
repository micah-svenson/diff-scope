#!/usr/bin/env bash

_dothis_completions()
{
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

 COMPREPLY=($(compgen -W "$(ls /usr/local/automation/bin)" -- "${COMP_WORDS[1]}"))
}

complete -F _dothis_completions panda
