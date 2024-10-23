HYPHEN_INSENSITIVE="true"

# TODO: not sure which of these I need or can move into nix
## make autocomplete more bash-like
setopt nomenucomplete
setopt noautomenu
setopt bashautolist
setopt globdots
setopt norecexact
#
## history option overrides
#setopt nosharehistory
#setopt noincappendhistory
#setopt incappendhistorytime
#setopt histverify

# no -R for less
unset LESS

# set ssh agent socket if using secretive
SECRETIVE_AUTH_SOCK="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
[ -S "$SECRETIVE_AUTH_SOCK" ] && export SSH_AUTH_SOCK="$SECRETIVE_AUTH_SOCK"

# The follwing is mostly "borrow" from a config I found; see
# https://github.com/Brettm12345/nixos-config/blob/master/modules/applications/shells/zsh/config.zsh


PROMPT_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
test -r "$PROMPT_CACHE" && source "$PROMPT_CACHE"

function fast-zpcompinit() {
  setopt extendedglob local_options
  autoload -Uz compinit
  local zcompf="${ZI[ZCOMPDUMP_PATH]:-${ZDOTDIR:-$HOME}/.zcompdump}"
  # use a separate file to determine when to regenerate, as compinit doesn't always need to modify the compdump
  local zcompf_a="${zcompf}.augur"

  if [[ -e "$zcompf_a" && -f "$zcompf_a"(#qN.md-1) ]]; then
      compinit -C -d "$zcompf"
  else
      compinit -i -d "$zcompf"
      touch "$zcompf_a"
  fi
  # if zcompdump exists (and is non-zero), and is older than the .zwc file, then regenerate
  if [[ -s "$zcompf" && (! -s "${zcompf}.zwc" || "$zcompf" -nt "${zcompf}.zwc") ]]; then
      # since file is mapped, it might be mapped right now (current shells), so rename it then make a new one
      [[ -e "$zcompf.zwc" ]] && mv -f "$zcompf.zwc" "$zcompf.zwc.old"
      # compile it mapped, so multiple shells can share it (total mem reduction)
      # run in background
      zcompile -M "$zcompf" &!
  fi
}

# Load immediately
zi ice depth=1 atload'!source ~/.config/zsh/p10k.zsh' atinit'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true'
zi light romkatv/powerlevel10k
#source ~/.config/zsh/p10k.zsh

setup-autosuggest() {
  bindkey -M viins '^e' autosuggest-accept
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
  ZSH_AUTOSUGGEST_USE_ASYNC=1
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5b6395'
}

setup-completion-generator() {
  alias gencomp='zi lucid nocd as"null" wait"1" atload"zi creinstall -q _local/config-files; fast-zpcompinit" for /dev/null; gencomp'
}

# Very important things
zi wait'0a' light-mode lucid nocompletions for \
  atinit'ZI[COMPINIT_OPTS]=-C; fast-zpcompinit; zpcdreplay' atpull'fast-theme XDG:overlay' \
    zdharma/fast-syntax-highlighting \
  compile'{src/*.zsh,src/strategies/*}' atinit'setup-autosuggest' atload'!_zsh_autosuggest_start' \
    zsh-users/zsh-autosuggestions

# Stuff that can wait a minute
zi wait'0b' light-mode lucid nocompletions for \
  pick'autopair.zsh' hlissner/zsh-autopair \

zi wait'0c' lucid light-mode for \
  chisui/zsh-nix-shell \

zi light-mode wait"1" lucid as"completion" for \
  zsh-users/zsh-completions \
  spwhitt/nix-zsh-completions


# tab completion matching is "fuzzy"
zstyle ':completion:*' matcher-list 'm:{a-z-_}={A-Z_-}' 'r:|=*' 'l:|=* r:|=*'

# In case we want to test config changes
[ -f ~/.zsh.test ] && . ~/.zsh.test
