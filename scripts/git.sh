#!/usr/bin/env bash

path="${1}"
reset_colour="#[fg=#868d9b]"

get_branch() {
    git -C "${path}" rev-parse --abbrev-ref HEAD || echo
}

get_revisions() {
    upstream=$(git -C "${path}" rev-parse --abbrev-ref --symbolic-full-name '@{u}')
    [ -z "${upstream}" ] && return

    declare -i behind
    declare -i ahead
    behind=$(git -C "${path}" rev-list --left-only --count "${upstream}...HEAD")
    ahead=$(git -C "${path}" rev-list --right-only --count "${upstream}...HEAD")

    out=""
    [ $behind -gt 0 ] && out+="-${behind}"
    [ $ahead -gt 0 ] && out+="+${ahead}"

    echo "${out}"

}

get_changes() {
    declare -i unstaged_added=0;
    declare -i unstaged_modified=0;
    declare -i unstaged_updated=0;
    declare -i unstaged_deleted=0;
    declare -i staged_added=0;
    declare -i staged_modified=0;
    declare -i staged_updated=0;
    declare -i staged_deleted=0;

    for change in $(git -C "${path}" status --porcelain=v2 | awk '{print $2}'); do
        case $change in
            '.A') unstaged_added+=1    ;;
            '.M') unstaged_modified+=1 ;;
            '.U') unstaged_updated+=1  ;;
            '.D') unstaged_deleted+=1  ;;
            'A.') staged_added+=1    ;;
            'M.') staged_modified+=1 ;;
            'U.') staged_updated+=1  ;;
            'D.') staged_deleted+=1  ;;
        esac
    done

    out=""
    [ $unstaged_added -gt 0 ] && out+="#[fg=color1]${unstaged_added}A "
    [ $unstaged_modified -gt 0 ] && out+="#[fg=color1]${unstaged_modified}M "
    [ $unstaged_updated -gt 0 ] && out+="#[fg=color1]${unstaged_updated}U "
    [ $unstaged_deleted -gt 0 ] && out+="#[fg=color1]${unstaged_deleted}D "
    [ $staged_added -gt 0 ] && out+="#[fg=color2]${staged_added}A "
    [ $staged_modified -gt 0 ] && out+="#[fg=color2]${staged_modified}M "
    [ $staged_updated -gt 0 ] && out+="#[fg=color2]${staged_updated}U "
    [ $staged_deleted -gt 0 ] && out+="#[fg=color2]${staged_deleted}D "

    echo "${out%% }"
}

main() {
    branch="$(get_branch)"
    [ -n "${branch}" ] && out="${branch}" || return

    revisions="$(get_revisions)"
    [ -n "${revisions}" ] && out+=" ${revisions}"

    changes="$(get_changes)"
    [ -n "${changes}" ] && out+=" ${changes}"

    echo "${out}${reset_colour}"
}

main
