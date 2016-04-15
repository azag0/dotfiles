set -g fish_prompt_pwd_dir_length 2

function fish_prompt
    set -l _status $status
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname | cut -c1-3)
    end

    if test -n "$SSH_CLIENT" -o -n "$SSH_CLIENT2"
        set _name_color green
        set _at_color red
    else
        set _name_color cyan
        set _at_color blue
    end
    echo -ns "🐟 "
    __mode_prompt
    echo -ns " " (set_color $_name_color) (echo $USER | cut -c1-3) \
        (set_color $_at_color) "@" (set_color $_name_color) $__fish_prompt_hostname " " \
        (set_color yellow) (prompt_pwd)

    if git rev-parse --is-inside-work-tree >/dev/null ^&1
        if git status --porcelain | egrep . >/dev/null ^&1
            set_color red
        else
            set_color green
        end
        set -l branch (git rev-parse --revs-only --abbrev-ref HEAD)
        if test -n "$branch"
            echo -ns " " $branch
        else
            echo -ns " <empty>"
        end if
    end
    set -l njobs (jobs | wc -l | string trim)
    if test $njobs -gt 0
        echo -ns (set_color blue) " $njobs"
    end
    if test $_status -ne 0
        echo -ns (set_color red) " [$_status]"
    end
    echo -ns (set_color normal) " "
end

function __mode_prompt --description "Displays the current mode"
    switch $fish_bind_mode
        case insert
            echo -ns (set_color -o white)
        case visual
            echo -ns (set_color magenta)
    end
    echo -ns (date "+%H:%M")
    set_color normal
end