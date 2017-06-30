find_git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  eval find_git_added
  eval find_git_commits

  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    git_branch="($branch$git_add$git_rev)"
  else
    git_branch=""
  fi
}

find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null | grep "^??")
  if [[ "$status" != "" ]]; then
    git_dirty='*'
  else
    git_dirty=''
  fi
}

find_git_added() {
  local status=$(git status --porcelain 2> /dev/null | grep "^\(A\|M\)")
  if [[ "$status" != "" ]]; then
    git_add='+'
  else
    git_add=''
  fi
}

find_git_commits() {
  local revlist_outdated=$(git rev-list --count --min-age=HEAD origin ^HEAD 2> /dev/null)
  local revlist_ahead=$(git rev-list --count --max-age=HEAD origin ^HEAD 2> /dev/null)  

  if [[ "$revlist_outdated" != "0" ]]; then
    git_rev='<'
  elif [[ "$revlist_ahead" -gt "1" ]]; then
    git_rev='>'
  else
    git_rev=''
  fi
}

PROMPT_COMMAND="find_git_branch; find_git_dirty; $PROMPT_COMMAND"

# Default Git enabled prompt with dirty state
# export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Another variant:
# export PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "

# Default Git enabled root prompt (for use with "sudo -s")
# export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
