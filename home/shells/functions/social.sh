social() {
    local DEV=${1?"must specify the serial device"}; shift
    local BAUD=${1:-9600}
    socat -,rawer,nonblock=1,escape=0x0f ${DEV},clocal=1,nonblock=1,ispeed=${BAUD},ospeed=${BAUD}
}
