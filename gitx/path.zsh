go() {
    cd "$(git rev-parse --show-cdup)$(git dir)"
}
