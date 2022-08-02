# Macos specific check for multiple ssh-agents and running the launchd ssh-agent.

ssh-fix-env() {
  SSH_AGENT_COUNT=$(pgrep ssh-agent | wc -l | tr -d " \n")
  if (( $SSH_AGENT_COUNT == 0 )); then
    ssh-agent -l # Mac specific.
  fi

  export SSH_AUTH_SOCK=$(launchctl getenv SSH_AUTH_SOCK)
  if [[ "$SSH_AUTH_SOCK" == "" ]]; then
    export SSH_AUTH_SOCK=$(lsof | grep ssh-agent | grep -E -o "/private/tmp/com.apple.*")
  fi

  export SSH_AGENT_PID=$(pgrep ssh-agent | head -1)

	FIX=$(cat <<-FIX
	SSH_AUTH_SOCK=$(launchctl getenv SSH_AUTH_SOCK)
	SSH_AGENT_PID=$(pgrep ssh-agent | head -1)
	Environment set/exported/active.
	FIX
  )
  SSH_FIX_MESSAGE=("${(@f)FIX}")

  if [[ "$1" != "quiet" ]]; then
    printbox $SSH_FIX_MESSAGE
  fi
}

ssh-agent-check() {
  SSH_AGENT_COUNT=$(pgrep ssh-agent | wc -l | tr -d " \n")
  SSH_AGENT_PLURAL=$((( SSH_AGENT_COUNT == 1 )) && echo "" || echo "s")
  DETECTED_PID=$(pgrep ssh-agent | head -1)

	OK=$(cat <<-OK
	($SSH_AGENT_COUNT) ssh-agent${SSH_AGENT_PLURAL} running on ${DETECTED_PID}.
	SSH_AUTH_SOCK: $SSH_AUTH_SOCK
	SSH_AGENT_PID: $SSH_AGENT_PID
	SSH env ok.
	OK
  )
  LINES_OK=("${(@f)OK}")

  WARN=$(cat <<-WARN
	($SSH_AGENT_COUNT) ssh-agent${SSH_AGENT_PLURAL} running on ${DETECTED_PID}.
	SSH_AUTH_SOCK: $SSH_AUTH_SOCK
	SSH_AGENT_PID: $SSH_AGENT_PID
	Launchd ssh-agent (sock): $(launchctl getenv SSH_AUTH_SOCK)
  lsof ssh-agent (sock): $(lsof | grep ssh-agent | grep -E -o "/private/tmp/com.apple.*")
	SSH env not set correctly, run ssh-fix-env
	WARN
  )
  LINES_WARN=("${(@f)WARN}")

  if ((${SSH_AGENT_COUNT} != 1)); then
    echo "(${SSH_AGENT_COUNT}) ssh-agents are running"
  else
    if [[ -n $SSH_AUTH_SOCK && -n $SSH_AGENT_PID ]]; then
      printbox $LINES_OK
    else
      printbox $LINES_WARN
    fi
  fi
}

is_ssh() {
  [[ -n $SSH_CLIENT ]] && echo $ZSH_THEME_IS_SSH_SYMBOL
}

