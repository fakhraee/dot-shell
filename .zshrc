# get bash complete to work in zsh
[[ -n "$ZSH_VERSION" ]] && autoload bashcompinit && bashcompinit

# colorize
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

# grml
[[ -f $HOME/.zshrc.grml ]] && source $HOME/.zshrc.grml

## to remove .zshrc.local
# liquid prompt
[[ $- = *i* ]] && source $HOME/opt/liquidprompt/liquidprompt

# some funcs and aliases
source $HOME/.shell

# fuzzy search
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# http://www.bash2zsh.com/essays/essay1_file_manager.html
alias -s pdf=mupdf
alias -s txt=less
alias -s png=mupdf
alias -s jpg=mupdf

# $PATH
export PATH="$PATH:$HOME/bin"
