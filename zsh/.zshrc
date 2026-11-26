# --- Config directory ---
export XDG_CONFIG_HOME="$HOME/.config"

# --- History ---
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# --- Fzf integration ---
eval "$(fzf --zsh)"

# Nordbones palette
export FZF_DEFAULT_OPTS="
--border=rounded
--margin=0,1
--padding=1
--reverse
--height=90%
--no-bold
--color=fg:#ebeef3,bg:#2f3541,fg+:#ebeef3,bg+:#545f70,hl:#87bfce,hl+:#82cce0
--color=border:#545f70,header:#a5b4cd,info:#8fbcba,prompt:#87bfce,pointer:#89cac8,marker:#a4be8d,spinner:#b38dac
--color=gutter:#2f3541,preview-bg:#2f3541
--preview-window=right:60%,border-left
"
# bat ships Nord, the closest built-in preview theme.
export FZF_BAT_THEME=Nord

# Solarized Light alternative (disabled; replaces the palette above).
# export FZF_DEFAULT_OPTS="
# --border=rounded
# --margin=0,1
# --padding=1
# --reverse
# --height=90%
# --no-bold
# --color=fg:#657b83,bg:#fdf6e3,fg+:#586e75,bg+:#eee8d5,hl:#b58900,hl+:#cb4b16
# --color=border:#93a1a1,header:#586e75,info:#2aa198,prompt:#268bd2,pointer:#dc322f,marker:#859900,spinner:#b58900
# --color=gutter:#eee8d5,preview-bg:#fdf6e3
# --preview-window=right:60%,border-left
# "
# unset FZF_BAT_THEME

# --- Shell keybindings ---

# Pick a file (Ctrl+T).
_fzf_file_transparent() {
	local file
	file=$(find . -type f 2>/dev/null | fzf --height=90% --reverse --border --preview 'bat --style=plain --theme="${FZF_BAT_THEME:-Solarized (light)}" --color=always --line-range :51 {}' --preview-window=right:60%)
	if [[ -n $file ]]; then
		LBUFFER+="$file"
	fi
	zle redisplay
}
zle -N _fzf_file_transparent
bindkey '^T' _fzf_file_transparent

# Jump to a directory (Ctrl+F).
_fzf_cd_transparent() {
	local dir
	dir=$(find . -type d 2>/dev/null | fzf --height=90% --reverse --border --preview-window=right:60% --preview='eza --tree --icons --color=always --level 2 {}')
	if [[ -n "$dir" ]]; then
		cd "$dir" || return
		zle reset-prompt
	fi
}
zle -N _fzf_cd_transparent
bindkey '^F' _fzf_cd_transparent

# Search command history (Ctrl+R).
_fzf_history_transparent() {
	local selected
	selected=$(fc -rl 1 | fzf --height=90% --reverse --border --tac | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//')
	if [[ -n $selected ]]; then
		BUFFER=$selected
		CURSOR=${#BUFFER}
	fi
	zle redisplay
}
zle -N _fzf_history_transparent
bindkey '^R' _fzf_history_transparent

# Search history by prefix with the arrow keys.
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# --- Aliases ---

# Pick a recent file or a man page.
alias nlof="~/scripts/fzf_listoldfiles.sh"
alias fman="print -l ${(k)commands} | fzf | xargs man"

# Directory listings (eza).
alias ls="eza --color=never --group-directories-first"
alias l="eza -l --color=never --group-directories-first"
alias la="eza -1la --color=never --group-directories-first"
alias lt="eza -T --color=never"   # tree view
alias lg="eza -l --git"

# Developer tools; piq runs without saving a session.
alias py='python3'
alias lc='leetgo'
alias piq='pi -p --no-session'

# --- Navigation and prompt ---
eval "$(zoxide init zsh --cmd cd)"

# eval "$(starship init zsh)"
source "$HOME/.config/zsh/bureau.zsh"

# --- Local scripts, plugins, and credentials ---
source ~/cp_garden/scripts/gator.sh
source ~/.fzf-marks/fzf-marks.plugin.zsh
source ~/.config/.private/api-key.zsh

# --- Editor and PATH ---
export EDITOR="nvim"

export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/Users/minh/.spicetify
export PATH=$PATH:~/cp_garden/scripts/bash
