CPU=$(uname -m)

case ${CPU} in
    armv7l)
        OS="rasp32"
        ;;
	aarch64)
		OS="rasp64"
        ;;
    *)
		if [[ "$(uname -r)" == *Microsoft* ]]; then
			OS="wsl"
		else
			OS="linux"
		fi		
        ;;
esac

export PATH=${HOME}/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH

if [[ "$OS" == "wsl" ]]; then
	export PATH=/mnt/c/scripts/rec-scripts:$PATH
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# ---------------------------------------------------------
# Enable Powerlevel10k
# ---------------------------------------------------------

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

if [[ "$OS" != "wsl" ]]; then
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
fi

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit ice wait lucid
zinit light zsh-users/zsh-completions # 補完

zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions # 補完

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light chrissicool/zsh-256color

zinit ice depth=1
zinit light romkatv/powerlevel10k

#if [[ "$OSTYPE" == "linux-gnu" ]]
#if [ "$(uname -i)" = "aarch64" ]; then

case ${OS} in
    rasp32)
        zinit ice from"gh-r" as"program" bpick"*linux_arm.*" pick"*/peco"
        zinit light "peco/peco"
        ;;
    *)
        zinit ice from"gh-r" as"program" pick"*/peco"
        zinit light "peco/peco"
		
		zinit ice from"gh-r" as"program" pick"bin/exa"
		zinit light "ogham/exa"
        ;;
esac

zinit ice from"gh-r" as"program" pick"*/ghq"
zinit light "x-motemen/ghq"

zinit ice from"gh-r" as"program" pick"*/hexyl"
zinit light "sharkdp/hexyl"

zinit ice from"gh-r" as"program" pick"*/diskus"
zinit light "sharkdp/diskus"

zinit ice from"gh-r" as"program" pick"*/bin/nvim"
zinit light "neovim/neovim"

# bat
zinit ice from"gh-r" as"program" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

# fd
zinit ice from"gh-r" as"program" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

zinit ice from"gh-r" as"program" mv"ripgrep* -> rg" pick"rg/rg"
zinit light BurntSushi/ripgrep

#enhanced
zinit ice wait'1' lucid pick'init.sh'; zinit light "b4b4r07/enhancd"

# Zsh保管を有効にするおまじない
zinit ice wait"!0" atinit"zpcompinit; zpcdreplay -q"
autoload -U compinit && compinit


: "Zshの設定" && {
	
	# 補完候補を自動表示
	setopt auto_list
	
	# TAB で順に補完候補を切り替える
	#setopt auto_menu
	
	#補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
	zstyle ':completion:*:default' menu select=1 
	
	#補完候補の色づけ
	export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
	zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
	
	
	# 入力した文字から始まるコマンドを履歴から検索し、上下矢印で補完
	#autoload -U up-line-or-beginning-search
	#autoload -U down-line-or-beginning-search
	#zle -N up-line-or-beginning-search
	#zle -N down-line-or-beginning-search
	#bindkey "^[[A" up-line-or-beginning-search
	#bindkey "^[[B" down-line-or-beginning-search

	# 他のzshと履歴を共有
	#setopt share_history

	# 選択されたテキストの背景色を変更し、ハイライトする
	zstyle ':completion:*:default' menu select=2

	# パスを直接入力してもcdする
	setopt auto_cd

	# 環境変数を補完
	setopt AUTO_PARAM_KEYS

	# コマンドラインがどのように展開され実行されたかを表示するようになる
	#setopt xtrace


	### 永続的なalias ###

	# exaがインストールされている場合のみ有効化
	if [[ $(command -v exa) ]]; then
		alias e='exa --icons --git'
		alias l=e
		#alias ls=e
		alias ea='exa -a --icons --git'
		alias la=ea
		alias ee='exa -aahl --icons --git'
		alias ll=ee
		alias et='exa -T -L 3 -a -I "node_modules|.git|.cache" --icons'
		alias lt=et
		alias eta='exa -T -a -I "node_modules|.git|.cache" --color=always --icons | less -r'
		alias lta=eta
		alias l='clear && e'
	fi
	
	alias relogin='exec $SHELL -l'

	######################################
	# zplugに関係無い設定はここらへんに適当に #
	######################################


	# ヒストリ(履歴)を保存、数を増やす
	HISTFILE=~/.zsh_history
	HISTSIZE=100000
	SAVEHIST=100000

	# ヒストリに保存するときに余分なスペースを削除する
	setopt hist_reduce_blanks 

	# 直前と同じコマンドの場合は履歴に追加しない
	setopt hist_ignore_dups

	setopt hist_ignore_all_dups # 重複するコマンドは古い法を削除する
	setopt hist_no_store # historyコマンドは履歴に登録しない
	setopt hist_verify # `!!`を実行したときにいきなり実行せずコマンドを見せる

	setopt auto_pushd

}


#Hide machine name
prompt_context () { }


 : "cd先のディレクトリのファイル一覧を表示する" && {
  [ -z "$ENHANCD_ROOT" ] && function chpwd { exa -T -L 1 } # enhancdがない場合
  [ -z "$ENHANCD_ROOT" ] || export ENHANCD_HOOK_AFTER_CD="exa -T -L 1" # enhancdがあるときはそのHook機構を使う
}

: "sshコマンド補完を~/.ssh/configから行う" && {
  #function _ssh { compadd $(fgrep 'Host ' ~/.ssh/*/config | grep -v '*' |  awk '{print $2}' | sort) }
}

function _ssh {
  compadd `fgrep 'Host ' ~/.ssh/config | grep -v '*' | awk '{print $2}' | sort`;
}


: "Pecoの設定" && {
	# peco Config
	function peco-select-history() {
		local tac
		if which tac > /dev/null; then
			tac="tac"
		else
			tac="tail -r"
		fi
		BUFFER=$(\history -n 1 | \
			eval $tac | \
			peco --query "$LBUFFER")
		CURSOR=$#BUFFER
		zle clear-screen
	}
	zle -N peco-select-history
	bindkey '^r' peco-select-history

	if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
		autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
		add-zsh-hook chpwd chpwd_recent_dirs
		zstyle ':completion:*' recent-dirs-insert both
		zstyle ':chpwd:*' recent-dirs-default true
		zstyle ':chpwd:*' recent-dirs-max 1000
		zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
	fi

	function peco-cdr () {
		local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
		if [ -n "$selected_dir" ]; then
			BUFFER="cd ${selected_dir}"
			zle accept-line
		fi
	}
	zle -N peco-cdr
	bindkey '^s' peco-cdr
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
