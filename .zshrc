
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="mytheme"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(
		git
		npm
		node
		python
		sudo
		copypath
		web-search
		history
		dirhistory
		colorize
		command-not-found
		colored-man-pages
		zsh-autosuggestions
		zsh-syntax-highlighting
	)

source $ZSH/oh-my-zsh.sh

# Import colorscheme from 'wal' asynchronously
# & # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.

# Alternative (blocks terminal for 0-3ms)

# To add support for TTYs this line can be optionally added.

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

export PATH="$HOME/.local/bin:$PATH"
