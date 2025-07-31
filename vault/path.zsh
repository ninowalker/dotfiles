load_vault_secrets() {
    local this_file_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    source "$this_file_dir/.env"
}

# load_vault_secrets
