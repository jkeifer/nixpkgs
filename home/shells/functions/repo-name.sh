repo-name() {
    local name="$(basename "$(git rev-parse --show-toplevel)")"
    [ -z "$name" ] || echo "$name"
}
