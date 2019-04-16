# disable greeting
set -U fish_greeting

# default edit
set -U EDITOR nvim

# mode
fish_default_key_bindings
#fish_vi_key_bindings

# set xdg home dir
set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config

# source shell functions
source $XDG_CONFIG_HOME/fish/functions/shell.fish

# fisher bootstrap
if not functions -q fisher
  echo installing fisher
  curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
  fish -c fisher
end
