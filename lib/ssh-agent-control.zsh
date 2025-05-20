# source from .zshrc

if [[ $USER == root ]]; then
    echo "Root user, skipping ssh-agent setup."
else
    if [[ -S /run/user/$UID/keyring/ssh ]]; then
        if [[ $SSH_AUTH_SOCK =~ "/run/user/$UID/keyring/" ]]; then
            echo "Connected to Gnome keyring ssh-agent"
        else
            export SSH_AUTH_SOCK=/run/user/$UID/keyring/ssh
        fi
    elif [[ -S /run/user/$UID/keyring/.ssh ]]; then
        if [[ $SSH_AUTH_SOCK =~ "/run/user/$UID/keyring/" ]]; then
            echo "Connected to Gnome keyring ssh-agent"
        else
            export SSH_AUTH_SOCK=/run/user/$UID/keyring/.ssh
        fi
    else
        PIDOF_AGENT_SOCK="$(ps -ax | rg "$(pidof ssh-agent).*?-a.*?\s*(/.*)" -r '$1')"
        export PIDOF_AGENT_SOCK="${PIDOF_AGENT_SOCK#"${PIDOF_AGENT_SOCK%%[![:space:]]*}"}"
        if [[ -s "$PIDOF_AGENT_SOCK" ]]; then
            export SSH_AUTH_SOCK="$PIDOF_AGENT_SOCK"
        fi

        if [[ $SSH_AUTH_SOCK == $HOME/.ssh/sock ]]; then
            echo "Connecting to zsh.d ssh-agent"
        fi

        if [[ $SSH_AUTH_SOCK =~ "${XDG_RUNTIME_DIR}/wezterm/agent" ]]; then
            echo "WezTerm ssh-agent proxy Gnome keyring"
        fi
    fi
    ssh-add -l 2>&1 | awk '{print "key: ",$3, $1, $4}'
fi
