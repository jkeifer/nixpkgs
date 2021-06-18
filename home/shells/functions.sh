social() {
    local DEV=${1?must specify the serial device}; shift
    local BAUD=${1:-9600}
    socat -,rawer,nonblock=1,escape=0x0f ${DEV},clocal=1,nonblock=1,ispeed=${BAUD},ospeed=${BAUD}
}

rmhk() {
    local _LINENUM=${1?must provide a line number in the known_hosts file to remove}; shift
    local _KNOWN_HOSTS=${1:-/Users/${USER}/.ssh/known_hosts}
    gsed "${_LINENUM}d" -i'.bak' ${_KNOWN_HOSTS}
}
