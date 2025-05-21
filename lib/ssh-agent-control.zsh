# source from .zshrc

ssh-show-keys() {
    ssh-add -l 2>&1 | awk '{print "key: ",$3, $1, $4}'
}

wsl-ssh-show-keys() {
    ssh-add.exe -l 2>&1 | awk '{print "key: ",$3, $1, $4}'
}

if [[ $USER == root ]]; then
    echo "Root user, skipping ssh-agent setup."
else
    # on WSL use the Windows host ssh-agent
    if command -v ssh.exe > /dev/null && command -v ssh-add.exe > /dev/null ; then
        alias ssh=ssh.exe
        alias ssh-add=ssh-add.exe
        git config --global core.sshCommand ssh.exe
        echo "WSL - connecting to Windows host ssh-agent"
        wsl-ssh-show-keys
    else # connect to ssh auth sock
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
            elif [[ $SSH_AUTH_SOCK =~ "${XDG_RUNTIME_DIR}/wezterm/agent" ]]; then
                echo "WezTerm ssh-agent proxy Gnome keyring"
            else
                echo "Connected to ssh-agent on $SSH_AUTH_SOCK"
            fi
        fi
    fi
fi

[[ -n $SSH_AUTH_SOCK ]] && ssh-show-keys
