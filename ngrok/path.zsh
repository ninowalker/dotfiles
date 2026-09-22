
ngrok-mutual-alien () {
    local port=3000
    if [[ $# -eq 1 ]]; then
        port=$1
    fi

    echo "Starting ngrok server on port $port..."
    ngrok http --domain=mutual-alien-keen.ngrok-free.app $port
}
