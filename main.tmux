#!/usr/bin/env bash

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

## end base settings

# color theming
tmux source-file "${CWD}/colours.conf"

