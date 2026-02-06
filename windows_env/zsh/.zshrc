# Enable completion
autoload -Uz compinit
compinit

# Starship prompt
eval "$(starship init zsh)"

# ── Autosuggestions configuration (BEFORE sourcing) ──
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
bindkey '^ ' autosuggest-accept

# Autosuggestions
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting (MUST be last)
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"