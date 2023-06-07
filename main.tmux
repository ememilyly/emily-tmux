#!/usr/bin/env bash

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#!/usr/bin/env bash

get_tmux_option() {
  _option=$1
  _default_value=$2
  _option_value=$(tmux show-option -gqv "${_option}")
  if [ -z "${_option_value}" ]; then
    echo "${_default_value}"
  else
    echo "${_option_value}"
  fi
}

## variables

tmux set-option -g @primary_colour "$(get_tmux_option "@primary_colour" "color3")"
tmux set-option -g @accent_colour "$(get_tmux_option "@accent_colour" "color1")"

## end variables


## base settings
# scripts
battery="${CWD}/scripts/battery.sh"

# set statusbar update interval
tmux set-option -g status-interval 1

# statusbar formatting
tmux set-option -g status-left ""
tmux set-option -g status-right "#(${battery}) %A%e %b %k:%M:%S"

# window status formatting
tmux set-option -wg window-status-current-format "#{?window_zoomed_flag,#[fg=default bold],#[fg=default]} #{window_index} #{window_name} "
tmux set-option -wg window-status-format "#{?window_zoomed_flag,#[fg=default bold],#[fg=default]} #{window_index} #{window_name} "

# can't do this in .conf
set-option -g display-panes-active-colour "#{@primary_colour}"

## end base settings

# color theming
tmux source-file "${CWD}/colours.conf"

