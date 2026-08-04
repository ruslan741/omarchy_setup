function afmagic_dashes {
  # check either virtualenv or condaenv variables
  local python_env_dir="${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}"
  local python_env="${python_env_dir##*/}"

  # if there is a python virtual environment and it is displayed in
  # the prompt, account for it when returning the number of dashes
  if [[ -n "$python_env" && "$PS1" = *\(${python_env}\)* ]]; then
    echo $(( COLUMNS - ${#python_env} - 3 ))
  elif [[ -n "$VIRTUAL_ENV_PROMPT" && "$PS1" = *${VIRTUAL_ENV_PROMPT}* ]]; then
    echo $(( COLUMNS - ${#VIRTUAL_ENV_PROMPT} - 3 ))
  else
    echo $COLUMNS
  fi
}

# primary prompt: dashed separator, directory and vcs info
#PS1="\${(l.\$(afmagic_dashes)..-.)}%{$reset_color%}
PS1="%~\$(git_prompt_info)\$(hg_prompt_info) %(!.#.»)%{$reset_color%} "
#PS2="%{$reset_color%}"

# right prompt: return code, virtualenv and context (user@host)
RPS1="%(?..? ↵%{$reset_color%})"
if (( $+functions[virtualenv_prompt_info] )); then
  RPS1+='$(virtualenv_prompt_info)'
fi
RPS1+="%n@%m%{$reset_color%}"

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"

# hg settings
ZSH_THEME_HG_PROMPT_PREFIX=" (%F{#1FFF76}"
ZSH_THEME_HG_PROMPT_CLEAN=""
ZSH_THEME_HG_PROMPT_DIRTY="*%{$reset_color%}"
ZSH_THEME_HG_PROMPT_SUFFIX=")%{$reset_color%}"

# virtualenv settings
ZSH_THEME_VIRTUALENV_PREFIX=" ["
ZSH_THEME_VIRTUALENV_SUFFIX="]%{$reset_color%}"

# Основные цвета (перед загрузкой плагина)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)

# Настройка цветов для разных типов токенов
#ZSH_HIGHLIGHT_STYLES[command]='fg=#FFD205,bold'           # существующая команда
#ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#F60010,bold'       # неизвестная команда
#ZSH_HIGHLIGHT_STYLES[builtin]='fg=#1FFF76'               # встроенные команды
#ZSH_HIGHLIGHT_STYLES[alias]='fg=#1FFF76'                   # алиасы
#ZSH_HIGHLIGHT_STYLES[path]='underline'                  # пути
#ZSH_HIGHLIGHT_STYLES[precommand]='fg=#FF3CBF'              # команды перед путями (sudo, time и т.д.)
#ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#A4A5AA' # опции с одной чертой (-l)
#ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#A4A5AA' # опции с двумя чертами (--help)
