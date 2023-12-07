rmhk() {
    local _LINENUM=${1?"must provide a line number in the known_hosts file to remove"}; shift
    local _KNOWN_HOSTS=${1:-"/Users/${USER}/.ssh/known_hosts"}
    gsed "${_LINENUM}d" -i'.bak' ${_KNOWN_HOSTS}
}
