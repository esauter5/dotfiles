autoload -Uz promptinit zmv colors
colors
PROMPT="%(2j.%j jobs are running .%(1j.%j job is running .))%# "
promptinit && prompt bart red cyan green yellow

zstyle ':completion::complete:*' use-cache 1

#export TERM=${TERM:/xterm/xterm-256color} #Workaround Terminal/vte bug/argument.

function running_osx() {
  uname -a | grep -qi darwin 
}

function running_linux() {
  uname -a | grep -qi linux
}

if running_linux; then
  eval `keychain --eval --quiet --quick --agents ssh`
  function add_all_ssh_keys()
  {
    ssh-add $(grep -lR PRIVATE ~/.ssh)
    if [ -n "${TMUX+x}" ]; then
      tmux set-environment SSH_AGENT_PID $SSH_AGENT_PID
      tmux set-environment SSH_AUTH_SOCK $SSH_AUTH_SOCK
    fi
}
alias ssh="(ssh-add -l > /dev/null || add_all_ssh_keys ) && ssh"
fi

bindkey -v
bindkey ' ' magic-space
bindkey -v ^R history-incremental-search-backward
bindkey -v ^F history-incremental-search-forward

#autoload predict-on
#zle -N predict-on
#zle -N predict-off
#bindkey '^X^Z' predict-on
#bindkey '^Z' predict-off
#predict-on


### http://www.zsh.org/mla/users/2002/msg00138.html ############
function __up_or_down_line_or_beginning_search {               #
if [[ $LASTWIDGET != down-line-or-beginning-search &&          #
      $LASTWIDGET != up-line-or-beginning-search ]]; then      #
    local LBUFFER_STRIPPED="${LBUFFER/#[       ]#/}"           #
    if [[ $RBUFFER == *$'\n'* ||                               #
          ${LBUFFER_STRIPPED} == "" ]]; then                   #
        __last_up_line=up-line-or-history                      #
        __last_down_line=down-line-or-history                  #
    else                                                       #
        LBUFFER_STRIPPED="${LBUFFER_STRIPPED/#[^   ]#[   ]#/}" #
        if [[ "$LBUFFER_STRIPPED" == "" ]]; then               #
            __last_up_line=up-line-or-search                   #
            __last_down_line=down-line-or-search               #
        else                                                   #
            __last_up_line=history-beginning-search-backward   #
            __last_down_line=history-beginning-search-forward  #
        fi                                                     #
    fi                                                         #
fi                                                             #
}                                                              #
zle -N __up_or_down_line_or_beginning_search                   #
                                                               #
function up-line-or-beginning-search {                         #
    __up_or_down_line_or_beginning_search                      #
    zle .${__last_up_line:-beep}                               #
}                                                              #
                                                               #
function down-line-or-beginning-search {                       #
    __up_or_down_line_or_beginning_search                      #
    zle .${__last_down_line:-beep}                             #
}                                                              #
                                                               #
zle -N up-line-or-beginning-search                             #
zle -N down-line-or-beginning-search                           #
                                                               #
bindkey "^[[A" up-line-or-beginning-search                     #
bindkey "^[[B" down-line-or-beginning-search                   #
### http://www.zsh.org/mla/users/2002/msg00138.html ############

setopt always_to_end
setopt auto_cd
setopt auto_pushd
setopt c_bases
setopt nocorrect
setopt extended_glob
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
##  ##  setopt ksh_arrays # On Thu 02 Jun 2011 12:20:24 PM EDT this broke tab completion. The effect is that arrays are zero-indexed with ksh_arrays set, and one-indexed without.
setopt list_packed
setopt list_rows_first
setopt null_glob
setopt path_dirs
setopt pushd_ignore_dups
setopt pushd_silent
setopt share_history
setopt short_loops

SAVEHIST=100000
HISTSIZE=100000
HISTFILE="${HOME}/.zsh_history"
READNULLCMD=less
REPORTTIME=7
typeset -U PATH="./bin:${HOME}/local/bin:${HOME}/local/sbin:${HOME}/.local/bin:/sbin:/usr/local/bin:$PATH:/usr/local/share/npm/bin"

export LESS="-RXei"
export EDITOR="vim"


if running_osx; then
  export LSCOLORS=ExfxcxdxbxExExabagacad
  alias	ls="ls -hFG"
elif running_linux; then
  alias ls="ls -hF --color"
fi

alias les="less"
alias	ll="ls -thor"
alias l1="ls -1"
alias	l="ls -1rt"
alias	rm="rm -i"
alias	mv="mv -i"
alias	cp="cp -i"
alias pop="popd"
alias p="pushd"
alias pp="cd ~2"
alias ri="ri -f ansi"
alias h="history"
if running_linux; then
  alias open="xdg-open"
fi
alias e='exec'
alias gst='git status'
alias ta='tmux -2 attach || tn'
alias b="bundle"
alias bi="b install --path vendor"
alias bil="bi --local"
alias bu="b update"
alias be="b exec"
alias binit="bi && b package && echo 'vendor/ruby' >> .gitignore"

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
chruby 2

t ()
{
  tmux new-window "$*"
}

tv ()
{
  tmux new-window "mvim -v"
}

tn ()
{
  tmux -2 new -s $(basename $(pwd))
}

didi ()
{
   (history 1 | grep -v "didi" | grep "$*") || (grep "$*" $HISTFILE | grep -v didi)
}

order ()
{
   sort $1 | uniq -c | sort -n
}

function chpwd()
{
   clear
   ll -A
}

function fix_tmux_env()
{
  # Sometimes my tmux sessions get muddled. I SHOULD find and correct the
  # problem, but for now, exporting these variables fixes it.
  tmux set-environment PATH $PATH
  tmux set-environment GEM_HOME $GEM_HOME
  tmux set-environment GEM_PATH $GEM_PATH
}

function decolor()
{
  sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"
}

function dos2unix()
{
  tr -d '\r'
}

function unix2dos()
{
  sed -e 's,\r*$,\r,'
}

function run_parallel_integration_test()
{
  clear
  sleep $[ RANDOM % 30 ] # To stagger starts a little bit
  bundle exec rspec acceptance/*(on[ $[ 1 + $(echo $TMUX_PANE | tr -d '%') % $(ls -1 acceptance | wc -l) ] ])
}

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' completions '1 '
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' glob '1 '
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' substitute '1 '
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/paul/.zshrc'
fpath=(/usr/local/share/zsh-completions $fpath)


autoload -Uz compinit
compinit
# End of lines added by compinstall

function man () {
	env\
          LESS_TERMCAP_mb=$(printf "\e[1;31m")\
          LESS_TERMCAP_md=$(printf "\e[1;31m")\
          LESS_TERMCAP_me=$(printf "\e[0m")\
          LESS_TERMCAP_se=$(printf "\e[0m")\
          LESS_TERMCAP_so=$(printf "\e[1;44;33m")\
          LESS_TERMCAP_ue=$(printf "\e[0m")\
          LESS_TERMCAP_us=$(printf "\e[1;32m")\
          man "$@"
}
