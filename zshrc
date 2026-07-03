# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/bradleylaming/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# ====================================================================
# ENVIRONMENT VARIABLES & PATH DEFINITIONS
# ====================================================================

# Forces terminal tools to use Neovim as the default text editor
export EDITOR="nvim"

# ====================================================================
# FZF UI CONFIGURATION VARIABLES
# ====================================================================
# Re-themes the standard black and white FZF popup window into Catppuccin Macchiato
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi --height 50% --layout reverse --border rounded"

# Adds a live syntax-highlighted visual preview engine on the right side when using Ctrl+T
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'batcat --style=numbers --color=always --line-range :500 {}'
  --preview-window 'right:50%:wrap'"

# ====================================================================
# CLI TOOL ALIAS REPLACEMENTS
# ====================================================================
alias ls='eza --icons --git --group-directories-first'
alias ll='eza -lbF --icons --git --group-directories-first'
alias cat='batcat --style=plain'

# Custom FZF command pipeline to kill hanging applications via interactive menu
alias kp="ps -ef | fzf --preview 'echo {}' --preview-window=down:10%:wrap --query='' | awk '{print \$2}' | xargs kill -9"

# ====================================================================
# INTERACTIVE TAB-COMPLETION BEHAVIORS
# ====================================================================
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Forces case-insensitivity
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # Mirrors matching core colors

# ====================================================================
# THIRD-PARTY PLUGINS & PROMPT KICKSTART
# ====================================================================
# Sources the real-time background syntax-highlighting engine
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Links FZF standard keybindings (Ctrl+R, Ctrl+T, Alt+C)
[[ -n $TMUX ]] && unset OSC
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="$HOME/.local/bin:$PATH"

# Triggers Starship to build the shell prompt interface
eval "$(starship init zsh)"
alias vim='/usr/bin/vim.gtk3'
