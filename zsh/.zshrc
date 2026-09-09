# Set XDG config home
export XDG_CONFIG_HOME="$HOME/.config"

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# --- FZF + theme for Ghostty ---
# Enable fzf key bindings
eval "$(fzf --zsh)"

#🎨 FZF Theme: Solarized Light
export FZF_DEFAULT_OPTS="
--border=rounded
--margin=0,1
--padding=1
--reverse
--height=90%
--no-bold
--color=fg:#657b83,bg:#fdf6e3,fg+:#586e75,bg+:#eee8d5,hl:#b58900,hl+:#cb4b16
--color=border:#93a1a1,header:#586e75,info:#2aa198,prompt:#268bd2,pointer:#dc322f,marker:#859900,spinner:#b58900
--color=gutter:#eee8d5,preview-bg:#fdf6e3
--preview-window=right:60%,border-left
"

#🎨 FZF Theme: Nord Dark (disabled)
# export FZF_DEFAULT_OPTS="
# --border=rounded
# --margin=0,1
# --padding=1
# --reverse
# --height=90%
# --no-bold
# --color=fg:#d8dee9,bg:#2e3440,fg+:#eceff4,bg+:#3b4252,hl:#88c0d0,hl+:#81a1c1
# --color=border:#4c566a,header:#d8dee9,info:#8fbcbb,prompt:#88c0d0,pointer:#81a1c1,marker:#a3be8c,spinner:#b48ead
# --color=gutter:#3b4252,preview-bg:#2e3440
# --preview-window=right:60%,border-left
# "

# Function: FZF file picker (Ctrl+T)
_fzf_file_transparent() {
	local file
	file=$(find . -type f 2>/dev/null | fzf --height=90% --reverse --border --preview 'bat --style=plain --theme="Solarized (light)" --color=always --line-range :51 {}' --preview-window=right:60%)
	if [[ -n $file ]]; then
		LBUFFER+="$file"
	fi
	zle redisplay
}
zle -N _fzf_file_transparent
bindkey '^T' _fzf_file_transparent

# Function: FZF cd (Ctrl + G)
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

# Function: FZF history search (Ctrl+R)
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

# called from ~/scripts/
alias nlof="~/scripts/fzf_listoldfiles.sh"
# opens documentation through fzf (eg: git,zsh etc.)
alias fman="print -l ${(k)commands} | fzf | xargs man"

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forwardsource

# --- Editor ---
export EDITOR="vim"


# ---- Eza (better ls) -----

alias l="ls -l --color=never"
alias la="eza -1la --color=never --group-directories-first"
alias lt="eza -T --color=never"   # tree view
alias lg="eza -l --git"

# alias for newlatex
alias newlatexmit='cp -r ~/latex-templates/mit-style/ ./'
alias newlatex='cp -r ~/latex-templates/random-style/ ./'

# alias for python
alias py='python3'

# alias for gcc
alias g++='g++-15'

# alias for leetgo
alias lc='leetgo'

eval "$(zoxide init zsh --cmd cd)"

#eval "$(starship init zsh)"
source "$HOME/.config/zsh/bureau.zsh"

source ~/cp_garden/scripts/bash/cp_vim.zsh
source ~/cp_garden/scripts/bash/cp_tools.zsh
source ~/.fzf-marks/fzf-marks.plugin.zsh
source ~/.config/.private/api-key.zsh

export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/Users/minh/.spicetify
export PATH=$PATH:~/cp_garden/scripts/bash
