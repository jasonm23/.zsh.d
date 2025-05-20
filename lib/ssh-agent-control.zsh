# source from .zshrc

if [[ $USER == root ]]; then
    echo "Root user, skipping ssh-agent setup."
else
  if [[ $SSH_AUTH_SOCK == "$(ps -ax | rg "$(pidof ssh-agent).*?-a.*?(/.*)" -r '$1')" ]]; then
      echo "Connecting to Gnome Keyring ssh-agent"
  elif [[ $SSH_AUTH_SOCK == $HOME/.ssh/sock ]]; then
      echo "Connecting to zsh.d ssh-agent"
      export SSH_AGENT_PID=$(pidof ssh-agent)
  elif [[ -n $SSH_AUTH_SOCK ]]; then
       echo "ssh-agent on ${SSH_AUTH_SOCK}"
  elif [[ -z $SSH_AUTH_SOCK ]]; then
      if pidof ssh-agent; then
          echo "ssh-agent found at $(pidof ssh-agent)"
      else
          echo "no ssh-agent found, starting from .zsh.d"
          eval $(ssh-agent -a $HOME/.ssh/sock)
      fi
  fi
  ssh-add -l
fi
