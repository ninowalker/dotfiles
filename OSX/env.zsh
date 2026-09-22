if [[ $(uname -s) == "Darwin" ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    if [[ ! -L /Library/Java/JavaVirtualMachines/openjdk.jdk ]] && [[ -d /usr/local/opt/openjdk/libexec/openjdk.jdk ]]; then
        ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
        export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home"
    fi
fi
