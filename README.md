# Fish Theme: clearance2

A minimalist [fish shell](http://fishshell.com/) theme for people who use git. Forked from [cseelus/clearance-fish](https://github.com/cseelus/clearance-fish).

![clearance2 theme](https://raw.github.com/james2doyle/theme-clearance2/master/preview.png)

## Install

```
git clone git@github.com:james2doyle/theme-clearance2.git $HOME/.local/share/omf/themes/clearance2
omf theme clearance2
```

## Config

My main difference in this theme is that you can tweak the config.

This is the default setup:

* `set -g theme_prompt_char_normal '❯ '`
* `set -g theme_prompt_virtual_env_char_begin '['`
* `set -g theme_prompt_virtual_env_char_end ']'`
* `set -g theme_prompt_git_char_begin '('`
* `set -g theme_prompt_git_char_end ')'`
* `set -g theme_prompt_git_is_dirty '±'`
* `set -g theme_prompt_divider ' · '`
* `set -g theme_prompt_newline yes`
* `set -g theme_prompt_full_path yes` (prefixed with `.../`)
* `set -g theme_prompt_ahead_behind_status yes`
* `set -g theme_prompt_git_ahead_glyph \u2191 # '↑'`
* `set -g theme_prompt_git_behind_glyph \u2193 # '↓'`
