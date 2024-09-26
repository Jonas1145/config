export PATH=$HOME/.local/bin:$PATH
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
[[ -n "$WT_SESSION" ]] && {
  chpwd() {
    echo -en '\e]9;9;"'
    wslpath -w "$PWD" | tr -d '\n'
    echo -en '"\x07'
  }
}
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export GOPATH=$HOME/go 
export GOROOT=/usr/local/go 
export GOBIN=$GOPATH/bin 
export PATH=$PATH:$GOPATH 
export PATH=$PATH:$GOROOT/bin # Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME="robbyrussell"
plugins=(git)

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
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias v="nvim"
alias "1"="cd ~/dev/work/decl/web-app-vite"
alias "2"="cd ~/dev/work/proebstel"
alias "9"="cd ~/dev/personal" 
alias "todo"="nvim ~/dev/work/todo.md"
alias "bat"="batcat"
alias "c"="clear"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Autostart tmux
if [ -z "$TMUX" ]; then
  # Checks if tmux is installed
  if command -v tmux &> /dev/null; then
    # Checks if a tmux session exists
    if tmux has-session 2>/dev/null; then
      # Attaches to existing session
      exec tmux attach
    else
      # Creates a new session
      exec tmux 
    fi
  else
    echo "tmux is not installed. You can install it with your package manager."
  fi
fi
