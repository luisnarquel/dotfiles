# Enable completion
autoload -Uz compinit
compinit

# aliases
alias ll='ls -lah --group-directories-first --color=auto 2>/dev/null'

# Starship prompt
eval "$(starship init zsh)"

# ── Autosuggestions configuration (BEFORE sourcing) ──
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
bindkey '^ ' autosuggest-accept

# Autosuggestions
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting (MUST be last)
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"