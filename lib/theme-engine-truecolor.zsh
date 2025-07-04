
# git theming

setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt

# Themable properties

: ${AT_COLOR="#FFFFFF"}
: ${BRACKET_COLOR="#c7a23c"}
: ${NAME_COLOR="#fff2d6"}
: ${MACHINE_COLOR="#ffaf00"}
: ${TIME_COLOR="#ffffff"}
: ${DATE_COLOR="#ffffff"}
: ${PATH_COLOR="#ffdf87"}
: ${RVM_COLOR="#ffaf00"}

: ${AT_COLOR="#FFFFFF"}
: ${AHEAD_COLOR="#EE8800"}
: ${AHEAD_ICON=""}
: ${BEHIND_COLOR="#00FFFF"}
: ${BEHIND_ICON=""}
: ${MERGING_COLOR="#CC33CC"}
: ${MERGING_ICON=" "}
: ${UNTRACKED_COLOR="#AA3333"}
: ${UNTRACKED_ICON="●"}
: ${MODIFIED_COLOR="#FFFFAA"}
: ${MODIFIED_ICON="●"}
: ${STAGED_COLOR="#559955"}
: ${STAGED_ICON="●"}
: ${REMOTE_COLOR="#83cbff"}
: ${REMOTE_ICON="  "}
: ${IS_MSYS_COLOR="#83cbff"}
: ${IS_MSYS_ICON="[msys]"}
: ${GIT_ICON=" "}
: ${GIT_ICON_COLOR="#FFFFFF"}
: ${GIT_LOCATION_COLOR="#FFFFFF"}
: ${DIVIDER="|"}
: ${ZSH_PROMPT_WEEK_DAY="%(0w,Sun,)%(1w,Mon,)%(2w,Tue,)%(3w,Wed,)%(4w,Thu,)%(5w,Fri,)%(6w,Sat,)"}

AHEAD="%F{$AHEAD_COLOR}${AHEAD_ICON} NUM%f"
BEHIND="%F{$BEHIND_COLOR}${BEHIND_ICON} NUM%f"
MERGING="%F{${MERGING_COLOR}}${MERGING_ICON}%f"
UNTRACKED="%F{${UNTRACKED_COLOR}}${UNTRACKED_ICON}%f"
MODIFIED="%F{$MODIFIED_COLOR}${MODIFIED_ICON}%f"
STAGED="%F{${STAGED_COLOR}}${STAGED_ICON}%f"

is_ssh() {
  [[ -n $SSH_CLIENT ]] && print "%F{$REMOTE_COLOR}${REMOTE_ICON}%f"
}

is_msys() {
  [[ -n $MSYSTEM ]] && print "%F{$IS_MSYS_COLOR}${IS_MSYS_ICON}%f"
}

# Echoes information about Git repository status when inside a Git repository
git_info() {
  # inside work tree or return
  git rev-parse --is-inside-work-tree > /dev/null 2>&1 || return

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  GIT_INFO+=( "%F{${GIT_ICON_COLOR}}${GIT_ICON}%f" )

  [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )

  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )

  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )

  GIT_INFO+=( "%F{${GIT_LOCATION_COLOR}}$GIT_LOCATION%f" )

  echo "%F{$BRACKET_COLOR}[% ${(j: :)GIT_INFO}%F{$BRACKET_COLOR}]%
  "
}

local day_of_week="%F{${BRACKET_COLOR}}${DIVIDER}%F{${DATE_COLOR}}${ZSH_PROMPT_WEEK_DAY}"

if [[ "${ZSH_PROMPT_WEEK_DAY}" == "" ]]; then
  day_of_week=""
fi

# Handle mandatory long var names
PROMPT='%F{${BRACKET_COLOR}}[%#%F{${NAME_COLOR}}%n%F{${AT_COLOR}}@%F{${MACHINE_COLOR}}%M$(is_msys)$(is_ssh)${day_of_week}%F{${BRACKET_COLOR}}${DIVIDER}%F{${TIME_COLOR}}%D{%I:%M%p}%F{${BRACKET_COLOR}}]$(git_info)
%F{${BRACKET_COLOR}}[%F{${PATH_COLOR}}%~%F{${BRACKET_COLOR}}]%f
'
