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

title-window() {
    echo -n -e "\033]0;$@\007"
}

repo-name() {
    local name="$(basename "$(git rev-parse --show-toplevel)")"
    [ -z "$name" ] || echo "$name"
}

set-aws-secrets() {
    local profile_name="${1:?"must provide profile name"}"
    local creds
    creds=$(aws configure export-credentials --profile "${profile_name}")
    rc=$?

    if [ "${rc}" -eq 255 ]; then
        # using sso and not logged in
        local sso_session="$(aws configure get sso_session --profile "${profile_name}")"

        if [ -n "${sso_session}" ]; then
            aws sso login --sso-session "${sso_session}"
        else
            aws sso login --profile "${profile_name}"
        fi

        creds=$(aws configure export-credentials --profile "${profile_name}")
    fi

    export AWS_ACCESS_KEY_ID="$(echo "${creds}" | jq -cr '.AccessKeyId')"
    export AWS_SECRET_ACCESS_KEY="$(echo "${creds}" | jq -rc '.SecretAccessKey')"
    export AWS_SESSION_TOKEN="$(echo "${creds}" | jq -rc '.SessionToken')"

    local region="$(aws configure get region --profile "${profile_name}")"
    # make sure to set this default region as makes sense to you
    region="${region:-"us-west-2"}"
    export AWS_DEFAULT_REGION="${region}"
    export AWS_REGION="${region}"
}

unset-aws-secrets() {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_DEFAULT_REGION
    unset AWS_REGION
}
