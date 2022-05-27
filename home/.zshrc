# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/jds6696/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="pi"
ZSH_THEME="spaceship"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
	 fzf
	 fzf-tab # must come beefore zsh-autosuggtestions or syntax-highlighting
	 thefuck
	 colored-man-pages
	 extract
	 zsh-autosuggestions
	 zsh-syntax-highlighting)

#ctrl-space accepts suggestion
bindkey '^ ' autosuggest-accept

# bindkey '^[^M' fuck-command-line

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Setup Homeshick to manage dotfiles
source "$HOME/.homesick/repos/homeshick/homeshick.sh"

# setup zoxide
eval "$(zoxide init zsh)"


# Aliases
# alias rr=ranger
# alias rd="ranger ~/Downloads/"
# alias bat=batcat
alias e='emacsclient -a ""'
alias et="emacsclient -a '' -nw"
alias m='emacsclient --eval "(progn (magit-status) (delete-other-windows))" -a ""'
alias mt="m -nw"
alias se="systemctl --user start emacs.service"
alias ke="systemctl --user stop emacs.service"
alias fuck.emacs="pkill -SIGUSR2 emacs"
alias fuck.mu="pkill -2 -u $UID mu"
alias FUCK.emacs="pkill -9 emacs"
# alias sense="watch -n 2 sensors"
alias R="R --no-save"


# aliases for common commands
#https://pennstate.service-now.com/sp?id=kb_article_view&sysparm_article=KB0013424&sys_kb_id=010bbde4db0070d07fb5266e1396190a&spa=1
# alias psu-connect="globalprotect connect -p secure-connect.psu.edu"
# alias psu-disconnect="globalprotect disconnect"
alias psu-letter="git clone https://github.com/jsilve24/psu_letterhead.git"



# add in borgmatic
PATH="$PATH:/root/.local/bin:/usr/sbin:/home/jds6696/.local/bin:/home/jds6696/bin"



#BW alias
# bwcopy() {
#     # if hash bw 2>/dev/null; then
#     if [[ -z "$BW_SESSION" ]]; then
#         echo -n Password:
#         read -s password
#         export BW_SESSION=$(bw unlock $password --raw)
#     fi

#     bw get item "$(bw list items | jq '.[] | "\(.name) | username: \(.login.username) | id: \(.id)" ' | fzf --with-nth 1..-4 | awk '{print $(NF -0)}' | sed 's/\"//g')" | jq '.login.password' | sed 's/\"//g' | xclip -sel clip
#     # fi
# }

# Set up printer in emacs
# Not sure this is needed or not
# PRINTER="Brother-HL-L2380DW-series"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jds6696/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jds6696/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jds6696/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jds6696/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<



# Shell side configuration for vterm
# https://github.com/akermu/emacs-libvterm
vterm_printf(){
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
}
setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'

# See https://github.com/akermu/emacs-libvterm for example usage
vterm_cmd() {
    local vterm_elisp
    vterm_elisp=""
    while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}
