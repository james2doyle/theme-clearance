# name: clearance2
# ---------------
# Based on clearance. Display the following bits on the left:
# - Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# - Current directory name
# - Git branch and dirty state (if inside a git repo)

set -g theme_prompt_char_normal '❯ '
set -g theme_prompt_virtual_env_char_begin '['
set -g theme_prompt_virtual_env_char_end ']'
set -g theme_prompt_git_char_begin '('
set -g theme_prompt_git_char_end ')'
set -g theme_prompt_git_is_dirty '±'
set -g theme_prompt_divider ' · '
set -g theme_prompt_newline yes
set -g theme_prompt_full_path yes
set -g theme_prompt_ahead_behind_status yes
set -g theme_prompt_git_ahead_glyph      \u2191 # '↑'
set -g theme_prompt_git_behind_glyph     \u2193 # '↓'

function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function __git_ahead_verbose -S -d 'Print a more verbose ahead/behind state for the current branch'
  set -l commits (command git rev-list --left-right '@{upstream}...HEAD' 2> /dev/null)
  or return

  set -l behind (count (for arg in $commits; echo $arg; end | command grep '^<'))
  set -l ahead (count (for arg in $commits; echo $arg; end | command grep -v '^<'))

  switch "$ahead $behind"
    case '' # no upstream
    case '0 0' # equal to upstream
      return
    case '* 0' # ahead of upstream
      echo " $theme_prompt_git_ahead_glyph $ahead"
    case '0 *' # behind upstream
      echo " $theme_prompt_git_behind_glyph $behind"
    case '*' # diverged from upstream
      echo " $theme_prompt_git_ahead_glyph $ahead$theme_prompt_git_behind_glyph $behind"
  end
end

function fish_prompt
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l normal (set_color normal)
  set -l black (set_color black)

  # Output the prompt, left to right

  # Add a newline before new prompts
  echo -e ''

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
      echo -n -s (set_color -b cyan black) $theme_prompt_virtual_env_char_begin (basename "$VIRTUAL_ENV") $theme_prompt_virtual_env_char_end $normal ' '
  end

  set -l pretty_path (pwd | sed "s:^$HOME:~:")

  set -l visual_path $blue$pretty_path
  if test $theme_prompt_full_path = no
    set visual_path $blue(basename $pretty_path | sed "s:^:.../:")
  end

  # Print pwd or full path
  echo -n -s $visual_path $normal

  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info $theme_prompt_git_char_begin $yellow $git_branch $theme_prompt_git_is_dirty $normal $theme_prompt_git_char_end
    else
      set git_info $theme_prompt_git_char_begin $green $git_branch $normal $theme_prompt_git_char_end
    end

    if test $theme_prompt_ahead_behind_status = yes
      echo -n -s $theme_prompt_divider $git_info $normal $black(__git_ahead_verbose)
    else
      echo -n -s $theme_prompt_divider $git_info $normal
    end
  end

  set -l last_status $status
  set -l prompt_color $red
  if test $last_status = 0
    set prompt_color $normal
  end

  if test $theme_prompt_newline = yes
    echo -e ''
  end
  # Terminate with a nice prompt char
  echo -e -n -s $prompt_color $theme_prompt_char_normal $normal
end
