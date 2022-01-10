if [[ ! -h /Library/Java/JavaVirtualMachines/openjdk.jdk ]] && [[ -d /usr/local/opt/openjdk/libexec/openjdk.jdk ]]; then
    ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
fi
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home"
