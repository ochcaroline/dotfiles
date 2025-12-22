autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

eval "$(starship init zsh)"
function set_win_title(){
    if [[ $PWD == $HOME ]]; then
        echo -ne "\033]0; ~ $shell_name \007"
        return
    else
        echo -ne "\033]0; $(basename ${PWD/$HOME/~}) $shell_name \007"
    fi
}
precmd_functions+=(set_win_title)

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Starting the ssh agent
eval $(ssh-agent) > /dev/null

# Git aliases
alias pull="git pull"
alias push="git push"
alias pushf="git push -f"
alias branch="git checkout"
alias branchn="git checkout -b"
alias main="git checkout main && git pull"
alias gr2="git rebase -i HEAD~2"
alias gr3="git rebase -i HEAD~3"
alias gr5="git rebase -i HEAD~5"
alias gr10="git rebase -i HEAD~10"
alias yeet-merged='git branch --merged | grep -Ev "(^\*|^\+|master|main|dev)" | xargs --no-run-if-empty git branch -d'

# Dir aliases
alias temp="cd /tmp"
alias sc="cd ~/source"

# Kubernetes
function kn () {
  kubectl get ns ; echo 
  if [[ "$#" -eq 1 ]]; then
    kubectl config set-context --current --namespace $1 ; echo
  fi
  echo "Current namespace [ $(kubectl config view --minify | grep namespace | cut -d " " -f6) ]"
}

alias k="kubectl"
alias kg="kubectl get"
alias kgp="kubectl get po"
alias kd="kubectl describe"
alias kdp="kubectl describe po"
alias kyeet="kubectl delete --force --grace-period=0"

export KUBE_EDITOR='nvim'

alias venvnew="python -m venv .venv"
alias venv=". ./venv/bin/activate"
alias dotvenv=". ./.venv/bin/activate"

alias deptree="pipdeptree --python ./venv/bin/python"
alias deptreereq="pipdeptree --python ./venv/bin/python | grep -E '^\w+' > requirements.txt"

# Misc aliases
alias vim=nvim
alias n="nvim ."
alias lb="liquibase"
alias g="gitui"
alias air='$(go env GOPATH)/bin/air'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

export PATH="$HOME/.jenv/bin:$PATH"

complete -F __start_kubectl k

if [[ -f ~/.secrets ]]; then
  set -a
  source ~/.secrets
  set +a
fi

export XDG_CONFIG_HOME=$HOME
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

source <(fzf --zsh)
eval "$(zoxide init zsh)"
eval "$(jenv init -)"
eval "$(thefuck --alias)"
source <(kubectl completion zsh)

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

export GPG_TTY=$(tty)

`test -z "$TMUX" && (tmux attach || tmux new-session)`
