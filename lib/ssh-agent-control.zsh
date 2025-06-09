ssh-list-keys() {
    local ssh_add_output
    ssh_add_output=$(ssh-add -l 2>&1)
    local ssh_add_exit_code=$?

    if [[ $status -ne 0 ]]; then
        if echo "$ssh_add_output" | grep -qE "Could not open a connection to your authentication
agent|Error connecting to agent"; then
            echo "No ssh-agent connection found."
        else
            echo "ssh-add error: $ssh_add_output"
        fi
        echo "is it here??"
        return $ssh_add_exit_code
    fi

    if [[ -z "$ssh_add_output" || "$ssh_add_output" == *"The agent has no identities."* ]]; then
        echo "No keys added to the ssh-agent."
        return 0
    fi

    if command -v wslpath 2>&1 > /dev/null; then # assume we are in wsl
      local winlogo=$(echo "󰨡")
      wslpath "$ssh_add_output" \
        | sed -E -e "s|[[:alpha:]]:/Users/[[:alpha:]]+?/|$winlogo@@\~/|" \
        | awk '{print "key: ", $3, $1, $4}' \
        | sed -E -e "s|@@|  |"
    else
      echo "$ssh_add_output" | awk '{print "key: ", $3, $1, $4}' 
    fi
}

if [[ $USER == root ]]; then
    echo "Root user, skipping ssh-agent setup."
else
    if command -v ssh-agent.exe > /dev/null && command -v npiperelay.exe > /dev/null && command -v socat > /dev/null ; then
        $HOME/.zsh.d/bin/ssh-wsl-socat.sh
        export SSH_AUTH_SOCK=$HOME/.ssh/sock
        ssh-list-keys
    else
        # fallback: connect to ssh auth sock on Linux side
        # Gnome
        if [[ -S /run/user/$UID/keyring/ssh ]]; then
            if [[ ! $SSH_AUTH_SOCK =~ "/run/user/$UID/keyring/" ]]; then
                export SSH_AUTH_SOCK=/run/user/$UID/keyring/ssh
            fi
        elif [[ -S /run/user/$UID/keyring/.ssh ]]; then
            if [[ ! $SSH_AUTH_SOCK =~ "/run/user/$UID/keyring/" ]]; then
                export SSH_AUTH_SOCK=/run/user/$UID/keyring/.ssh
            fi
        else
            PIDOF_AGENT_SOCK="$(ps -ax | rg "$(pidof ssh-agent).*?-a.*?\s*(/.*)" -r '$1')"
            export PIDOF_AGENT_SOCK="${PIDOF_AGENT_SOCK#"${PIDOF_AGENT_SOCK%%[![:space:]]*}"}"
            if [[ -S "$PIDOF_AGENT_SOCK" ]]; then
                export SSH_AUTH_SOCK="$PIDOF_AGENT_SOCK"
            fi
        fi

        if [[ -z $SSH_AUTH_SOCK ]]; then
            if pidof ssh-agent; then
                echo "Sock for ssh-agent $(pidof ssh-agent) not found"
                echo "Connect manually"
            else
                echo "Connecting to new ssh-agent on $HOME/.ssh/sock"
                eval $(ssh-agent -s -a $HOME/.ssh/sock)
            fi
        else # show status
            if [[ $SSH_AUTH_SOCK == $HOME/.ssh/sock ]]; then
                echo "Connected to zsh.d ssh-agent"
            elif [[ $SSH_AUTH_SOCK =~ "${XDG_RUNTIME_DIR}/keyring" ]]; then
                echo "Connected to Gnome keyring ssh-agent"
            elif [[ $SSH_AUTH_SOCK == "/tmp/ssh-*/agent.*" ]]; then
                echo "Connected to KDE/Gnome keyring ssh-agent"
            elif [[ -S /tmp/ssh*/agent* ]]; then
                for sock in /tmp/ssh*/agent*; do
                    echo "chcking KDE sockets..."
                    if [[ -S $sock ]]; then
                        export SSH_AUTH_SOCK=$sock
                        break
                    fi
                done
                echo "Connected to ssh-agent on $SSH_AUTH_SOCK"
            elif [[ $SSH_AUTH_SOCK == "${XDG_RUNTIME_DIR}/wezterm/agent" ]]; then
                echo "WezTerm ssh-agent proxy Gnome keyring"
            else
                echo "Connected to ssh-agent on $SSH_AUTH_SOCK"
            fi
        fi

        ssh-list-keys
    fi
fi

