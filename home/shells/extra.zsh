HYPHEN_INSENSITIVE="true"

# make autocomplete more bash-like
setopt nomenucomplete
setopt noautomenu
setopt bashautolist
setopt globdots

# history option overrides
setopt nosharehistory
setopt noincappendhistory
setopt incappendhistorytime
setopt histverify

# no -R for less
unset LESS

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
