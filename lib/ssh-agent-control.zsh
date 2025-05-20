# source from .zshrc

PIDOF_AGENT_SOCK="$(ps -ax | rg "$(pidof ssh-agent).*?-a.*?\s*(/.*)" -r '$1')"
export PIDOF_AGENT_SOCK="${PIDOF_AGENT_SOCK#"${PIDOF_AGENT_SOCK%%[![:space:]]*}"}"

if [[ $USER == root ]]; then
    echo "Root user, skipping ssh-agent setup."
else
  if [[ $SSH_AUTH_SOCK =~ "${XDG_RUNTIME_DIR}/keyring/" ]]; then
      echo "Connecting to Gnome keyring ssh-agent"
  elif [[ $SSH_AUTH_SOCK == $HOME/.ssh/sock ]]; then
      echo "Connecting to zsh.d ssh-agent"
  elif [[ $SSH_AUTH_SOCK =~ "${XDG_RUNTIME_DIR}/wezterm/agent" ]]; then
      echo "WezTerm ssh-agent proxy Gnome keyring"
  fi
  ssh-add -l 2>&1 | awk '{print "key: ",$3, $1, $4}'
fi
