function add_to_path() {
    if [[ -d "$2" ]]; then
        if [[ "$1" == "-p" ]] && [[ ":$PATH:" != *":$2:"* ]]; then
            export PATH="$2:$PATH"
            # echo "Directory prepended to PATH"
        elif [[ ":$PATH:" != *":$2:"* ]]; then
            export PATH="$PATH:$2"
            # echo "Directory appended to PATH"
        else
            # echo "Directory already in PATH"
            true
        fi
    else
        # echo "Directory does not exist"
        true
    fi
}
