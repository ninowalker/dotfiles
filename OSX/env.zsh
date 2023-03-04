if [[ $(uname -s) == "Darwin" ]]; then
    add_to_path -p /opt/homebrew/bin

    if [[ ! -L /Library/Java/JavaVirtualMachines/openjdk.jdk ]] && [[ -d /usr/local/opt/openjdk/libexec/openjdk.jdk ]]; then
        ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
        export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home"
    fi
fi
