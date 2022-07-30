# Macos specific check for multiple ssh-agents and running the launchd ssh-agent.

ssh-agent-check() {
  SSH_AGENT_COUNT=$(pgrep ssh-agent | wc -l | tr -d " \n")
  SSH_AGENT_PLURAL=$((( SSH_AGENT_COUNT == 1 )) && echo "" || echo "s")
  DETECTED_PID=$(pgrep ssh-agent | head -1)

  LINES_OK=(
     "($SSH_AGENT_COUNT) ssh-agent${SSH_AGENT_PLURAL} running on ${DETECTED_PID}."
     "SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
     "SSH_AGENT_PID: $SSH_AGENT_PID"
     "SSH env ok."
  )

  LINES_WARN=(
     "($SSH_AGENT_COUNT) ssh-agent${SSH_AGENT_PLURAL} running on ${DETECTED_PID}."
     "SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
     "SSH_AGENT_PID: $SSH_AGENT_PID"
     "Launchd ssh-agent (sock): $(launchctl getenv SSH_AUTH_SOCK)"
     "SSH env not set correctly, run ssh-fix-env\n"
  )

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

ssh-fix-env() {
  SSH_AGENT_COUNT=$(pgrep ssh-agent | wc -l | tr -d " \n")
  if (( $SSH_AGENT_COUNT == 0 )); then
    ssh-agent -l # Mac specific.
  fi

  export SSH_AUTH_SOCK=$(launchctl getenv SSH_AUTH_SOCK)
  export SSH_AGENT_PID=$(pgrep ssh-agent | head -1)

  SSH_FIX_MESSAGE=(
   "SSH_AUTH_SOCK=$(launchctl getenv SSH_AUTH_SOCK)"
   "SSH_AGENT_PID=$(pgrep ssh-agent | head -1)"
   "Environment set/exported/active."
  )

  if [[ "$1" != "quiet" ]]; then
    printbox $SSH_FIX_MESSAGE
  fi
}

is_ssh() {
  [[ -n "$SSH_CLIENT" ]] && echo $ZSH_THEME_IS_SSH_SYMBOL
}
