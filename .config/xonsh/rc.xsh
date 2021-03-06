# vim: ft=xonsh
from time import localtime, strftime
import json
import sys
from functools import wraps
import inspect


$VI_MODE = True
$PROMPT = (
    '🐌 {time} '
    '{CYAN}{short_cwd}{branch_color}{curr_branch} '
    '{NO_COLOR}'
)
$PROMPT_FIELDS['time'] = lambda: strftime('%H:%M', localtime())
$PROMPT_FIELDS['short_user'] = $USER[:3]
$XONSH_COLOR_STYLE = 'vim'
$SUGGEST_COMMANDS = False
$BASH_COMPLETIONS = []


aliases.update({
    '..': 'cd ..',
    '...': 'cd ../..',
    'll': 'ls -l',
    'la': 'ls -a',
    'lla': 'ls -la',
    'lt': 'ls -ltr',
    'py': 'python',
    'py3': 'python3',
    'pty': 'ptpython',
    'ipty': 'ptipython',
    'jupy': 'jupyter notebook',
    'sp': 'tmux split',
    'vsp': 'tmux split -h',
    'kp': 'tmux kill-pane',
    'gitk': 'gitk --all',
    'mk': 'make',
    'mku': 'make -C ..'
})


def _alias(f):
    aliases[f.__name__] = f
    return f


def alias(f):
    assert f.__name__[0] == '_'
    aliases[f.__name__[1:]] = f
    return f


def __xonshrc__():
    def get_all_history():
        for filename in `$XDG_DATA_HOME/xonsh/xonsh-.*.json`:
            with open(filename) as f:
                for cmd in json.load(f)['data']['cmds']:
                    yield cmd['ts'][0], cmd['inp']

    @_alias
    def print_all_history(args, stdin=None):
        for _, cmd in sorted(get_all_history()):
            sys.stdout.write(cmd)


__xonshrc__()
