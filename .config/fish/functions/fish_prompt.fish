function fish_prompt
    set -l _status $status
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname | cut -c1-3)
    end

    echo -ns "🐟 " (set_color cyan) (echo $USER | cut -c1-3) \
        (set_color blue) "@" (set_color cyan) $__fish_prompt_hostname " " \
        (set_color yellow) (prompt_pwd | \
            awk -F '/' '{ORS=""; for (i=1; i<NF; i++) print substr($i, 1, 1) "/"; print $NF}')

    if git rev-parse --is-inside-work-tree >/dev/null ^&1
        if git status --porcelain | egrep . >/dev/null ^&1
            set_color red
        else
            set_color green
        end
        echo -ns " " (git rev-parse --abbrev-ref HEAD)
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

function fish_right_prompt
    date "+%H:%M"
    echo -n " "
    __mode_prompt
end

function __mode_prompt --description "Displays the current mode"
    switch $fish_bind_mode
        case default
            echo -ns (set_color -o -b red white) "[N]"
        case insert
            echo -ns (set_color -o -b green white) "[I]"
        case visual
            echo -ns (set_color -o -b magenta white) "[V]"
    end
    set_color normal
end