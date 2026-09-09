# Standalone adaptation of the Oh My Zsh Bureau theme.
autoload -U colors && colors

_bureau_git_prefix="[%{$fg_bold[green]%}±%{$reset_color%}%{$fg_bold[white]%}"
_bureau_git_suffix="%{$reset_color%}]"
_bureau_git_clean="%{$fg_bold[green]%}✓%{$reset_color%}"
_bureau_git_ahead="%{$fg[cyan]%}▴%{$reset_color%}"
_bureau_git_behind="%{$fg[magenta]%}▾%{$reset_color%}"
_bureau_git_staged="%{$fg_bold[green]%}●%{$reset_color%}"
_bureau_git_unstaged="%{$fg_bold[yellow]%}●%{$reset_color%}"
_bureau_git_untracked="%{$fg_bold[red]%}●%{$reset_color%}"
_bureau_git_stashed="(%{$fg_bold[blue]%}✹%{$reset_color%})"

bureau_git_info() {
  local ref
  ref=$(command git symbolic-ref HEAD 2>/dev/null) || \
    ref=$(command git rev-parse --short HEAD 2>/dev/null) || return
  print -r -- "${ref#refs/heads/}"
}

bureau_git_status() {
  local result gitstatus gitfiles gitbranch
  gitstatus="$(command git status --porcelain -b 2>/dev/null)"
  gitfiles="$(tail -n +2 <<< "$gitstatus")"

  if [[ -n "$gitfiles" ]]; then
    [[ "$gitfiles" =~ $'(^|\n)[AMRD]. ' ]] && result+="$_bureau_git_staged"
    [[ "$gitfiles" =~ $'(^|\n).[MTD] ' ]] && result+="$_bureau_git_unstaged"
    [[ "$gitfiles" =~ $'(^|\n)[?][?] ' ]] && result+="$_bureau_git_untracked"
  else
    result+="$_bureau_git_clean"
  fi

  gitbranch="$(head -n 1 <<< "$gitstatus")"
  [[ "$gitbranch" =~ '^## .*ahead' ]] && result+="$_bureau_git_ahead"
  [[ "$gitbranch" =~ '^## .*behind' ]] && result+="$_bureau_git_behind"
  command git rev-parse --verify refs/stash &>/dev/null && result+="$_bureau_git_stashed"

  print -r -- "$result"
}

bureau_git_prompt() {
  command git rev-parse --git-dir &>/dev/null || return
  [[ "$(command git config --get oh-my-zsh.hide-info 2>/dev/null)" == 1 ]] && return

  local gitinfo output gitstatus
  gitinfo="$(bureau_git_info)" || return
  output="${gitinfo:gs/%/%%}"
  gitstatus="$(bureau_git_status)"
  [[ -n "$gitstatus" ]] && output+=" $gitstatus"
  print -r -- "${_bureau_git_prefix}${output}${_bureau_git_suffix}"
}

_bureau_path="%{$fg_bold[white]%}%~%{$reset_color%}"
if [[ $EUID -eq 0 ]]; then
  _bureau_user="%{$fg_bold[red]%}%n%{$reset_color%}@%m"
  _bureau_prompt="%{$fg[red]%}#%{$reset_color%}"
else
  _bureau_user="%{$fg_bold[white]%}%n%{$reset_color%}@%m"
  _bureau_prompt="%{$fg[green]%}$%{$reset_color%}"
fi

bureau_get_space() {
  local text="$1$2" zero='%([BSUbfksu]|([FB]|){*})'
  local length=${#${(S%%)text//$~zero/}}
  local spaces=$((COLUMNS - length - ${ZLE_RPROMPT_INDENT:-1}))
  ((spaces > 0)) || return
  printf ' %.0s' {1..$spaces}
}

_bureau_left="$_bureau_user $_bureau_path"
_bureau_right="[%*]"
bureau_precmd() {
  local spaces
  spaces="$(bureau_get_space "$_bureau_left" "$_bureau_right")"
  print
  print -rP "$_bureau_left$spaces$_bureau_right"
}

setopt prompt_subst
PROMPT="> $_bureau_prompt "
RPROMPT='$(bureau_git_prompt)'

autoload -U add-zsh-hook
add-zsh-hook precmd bureau_precmd
