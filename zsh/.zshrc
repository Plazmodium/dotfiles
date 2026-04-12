export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# uv
export PATH="/Users/gracz/.local/bin:$PATH"

alias fabric='fabric-ai'

eval "$(starship init zsh)"

# Load Angular CLI autocompletion.
source <(ng completion script)
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/gracz/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Begin ALIASES
# GLOBALS
alias bua='brew update && brew upgrade && brew upgrade --cask && brew cleanup'
alias oc='opencode'
alias lz='lazygit'


export AWS_PROFILE=sbsa-aws-azure-login
# LOCALS
# Only for ~/Developer/dvt-specific/clients/standard-bank/bcb-digital SBSA
alias aal='npx aws-azure-login --profile sbsa-aws-azure-login --mode gui'
# End ALIASES
