# source from .zshrc

PIDOF_AGENT_SOCK="$(ps -ax | rg "$(pidof ssh-agent).*?-a.*?\s*(/.*)" -r '$1')"
export PIDOF_AGENT_SOCK="${PIDOF_AGENT_SOCK#"${PIDOF_AGENT_SOCK%%[![:space:]]*}"}"

if [[ $USER == root ]]; then
    echo "Root user, skipping ssh-agent setup."
else
  if [[ $SSH_AUTH_SOCK =~ "/run/user/$UID/keyring/" ]]; then
      echo "Connecting to Gnome keyring ssh-agent"
      echo "${PIDOF_AGENT_SOCK}"
  elif [[ $SSH_AUTH_SOCK == $HOME/.ssh/sock ]]; then
      echo "Connecting to zsh.d ssh-agent"
  elif [[ -n $SSH_AUTH_SOCK ]]; then
      echo "ssh-agent on ${SSH_AUTH_SOCK}"
      echo "$PIDOF_AGENT_SOCK"
  elif [[ -z $SSH_AUTH_SOCK ]]; then
      if pidof ssh-agent; then
          echo "ssh-agent found at $(pidof ssh-agent)"
          echo "${PIDOF_AGENT_SOCK}"
      else
          echo "ssh-agent not found, starting from .zsh.d"
          eval $(ssh-agent -a $HOME/.ssh/sock)
      fi
  fi
  ssh-add -l
fi
