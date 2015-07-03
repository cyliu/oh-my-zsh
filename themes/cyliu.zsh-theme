BAT_CHARGE='batcharge.py'

function battery_charge {
    echo `$BAT_CHARGE` 2>/dev/null
}

function branch_name {
    git branch >/dev/null 2>/dev/null && echo '['`git branch | cut -f2 -d' '`'±]'
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    #echo '○'
    echo '$'
}

function folder {
    echo ${PWD/#$HOME/\~}
}

function last_folder {
    echo ${PWD/#$HOME/\~} | rev | cut -f1 -d'/' | rev
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function t_tasks {
    echo $(t | wc -l | sed -e's/ *//')
}

function t_A_tasks {
    echo $(t | grep '\[A\]' | wc -l | sed -e's/ *//')
}

function t_B_tasks {
    echo $(t | grep '\[B\]' | wc -l | sed -e's/ *//')
}

function t_Z_tasks {
    echo $(t | grep -v '\[A\]'| grep -v '\[B\]' | wc -l | sed -e's/ *//')
}

function t_status {
if [ "$(t_tasks)" -ne 0 ]; then
    STATUS="%{$fg[yellow]%}[%{$reset_color%}%{$fg_bold[yellow]%}$(t_tasks)%{$reset_color%}|"
    if [ "$(t_A_tasks)" -ne 0 ]; then
        STATUS="$STATUS%{$fg[red]%}$(t_A_tasks)%{$reset_color%}"
    fi
    if [ "$(t_B_tasks)" -ne 0 ]; then
        if [ "$(t_A_tasks)" -ne 0 ]; then
            STATUS="$STATUS%{$fg[yellow]%}:%{$reset_color%}"
        fi
        STATUS="$STATUS%{$fg[yellow]%}$(t_B_tasks)%{$reset_color%}"
    fi
    if [ "$(t_Z_tasks)" -ne 0 ]; then
        if [ "$(t_A_tasks)" -ne 0 || "$(t_B_tasks)" -ne 0 ]; then
            STATUS="$STATUS%{$fg[yellow]%}:%{$reset_color%}"
        fi
        STATUS="$STATUS%{$fg[yellow]%}:%{$reset_color%}%{$fg[green]%}$(t_Z_tasks)%{$reset_color%}"
    fi
    STATUS="$STATUS%{$fg[yellow]%}]%{$reset_color%}"
fi
echo "$STATUS"
}

TTASK='$(t_status)'
GITSTATUS='$(git_super_status)'
#ARROW='%{$fg_bold[red]%}>%{$fg_bold[yellow]%}>%{$fg_bold[green]%}>%{$reset_color%}⚡ '
ARROW='⚡ '
PROMPT=$TTASK$ARROW
FOLDER='%{$fg_bold[cyan]%}[$(folder)]%{$reset_color%}'
RPROMPT=$FOLDER$GITSTATUS

#PROMPT='%{$fg_bold[green]%}%n%{$reset_color%}%{$fg_bold[red]%}@%{$reset_color%}%{$fg_bold[yellow]%}%m%{$reset_color%}%{$fg[cyan]%}[${PWD/#$HOME/~}]%{$reset_color%}%{$fg_bold[green]%}$(prompt_char)%{$reset_color%}'
#RPROMPT='['`echo $(battery_charge)`' %{$fg[blue]%}%* %D%{$reset_color%}]'
