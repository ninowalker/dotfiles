if ! which brew > /dev/null; then
    if [[ -e /opt/homebrew/bin/brew ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
    fi
fi

if [[ ! -h /Library/Java/JavaVirtualMachines/openjdk.jdk ]] && [[ -d /usr/local/opt/openjdk/libexec/openjdk.jdk ]]; then
    ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
fi
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home"
