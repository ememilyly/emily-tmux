#!/usr/bin/env bash

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
scripts_dir="${CWD}/scripts"

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

tmux set-option -g status-right-length 256 # be longer (arbitrary, default was 40)
tmux set-option -g @primary_colour "$(get_tmux_option "@primary_colour" "color3")"
tmux set-option -g @accent_colour "$(get_tmux_option "@accent_colour" "color1")"

## end variables


## base settings
# set statusbar update interval
tmux set-option -g status-interval 1

# statusbar formatting
tmux set-option -g status-left ""
tmux set-option -g status-right "#(${scripts_dir}/git.sh #{pane_current_path}) #(${scripts_dir}/battery.sh) %A %d/%m %H:%M:%S"

# window status formatting
tmux set-option -wg window-status-current-format "#{?window_zoomed_flag,#[fg=default bold],#[fg=default]} #{window_index} #{window_name} "
tmux set-option -wg window-status-format "#{?window_zoomed_flag,#[fg=default bold],#[fg=default]} #{window_index} #{window_name} "

# can't do this in .conf
tmux set-option -g display-panes-active-colour "$(tmux show-option -gqv @primary_colour)"

## end base settings

# color theming
tmux source-file "${CWD}/colours.conf"
