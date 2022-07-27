
ssh-agent-check() {
  SSH_AGENT_COUNT=$(pgrep ssh-agent | wc -l | tr -d " ")
  if ((${SSH_AGENT_COUNT} != 1)); then
    echo "(${SSH_AGENT_COUNT}) ssh-agents are running"
  else
    echo "ok"
  fi
}

ssh-agent-sock() {
  agent_pid=$1
  SSH_AUTH_SOCK=$(lsof | grep ssh-agent | grep -E -o "/var/folders.*")
}

ssh-fix-env() {
  echo "export SSH_AGENT_PID=$(pgrep ssh-agent | head -1)"
  echo "export SSH_AUTH_SOCK=$(lsof  | \
      grep -E "ssh-agent.*/private/tmp/com.apple.launchd.*$" | \
      grep -E -o "/private/tmp/com.apple.launchd.*$")"
}

is_ssh() {
  [[ -n "$SSH_CLIENT" ]] && echo $ZSH_THEME_IS_SSH_SYMBOL
}
