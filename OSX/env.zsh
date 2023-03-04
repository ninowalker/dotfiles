if [[ $(uname -s) == "Darwin" ]]; then
    if ! which brew >/dev/null; then
        if [[ -e /opt/homebrew/bin/brew ]]; then
            export PATH="/opt/homebrew/bin:$PATH"
        fi
    fi

    if [[ ! -L /Library/Java/JavaVirtualMachines/openjdk.jdk ]] && [[ -d /usr/local/opt/openjdk/libexec/openjdk.jdk ]]; then
        ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
        export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home"
    fi
fi
