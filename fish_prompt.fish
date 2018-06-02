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

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function fish_prompt
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l normal (set_color normal)

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
    set visual_path $blue(basename $pretty_path)
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
    echo -n -s $theme_prompt_divider $git_info $normal
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
