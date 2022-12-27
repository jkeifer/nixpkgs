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


set-secrets() {
    local profile_name="${1:?must provide profile name}"
    local sso_url="$(aws configure get sso_start_url --profile "${profile_name}")"
    local now="$(date -u "+%Y%m%d%H%M%S")"
    local region="$(aws configure get region --profile "${profile_name}")"
    region="${region:-us-west-2}"

    if [ -n "$sso_url" ]; then
        local role_name="$(aws configure get sso_role_name --profile "${profile_name}")"
        local account_id="$(aws configure get sso_account_id --profile "${profile_name}")"

        local sso_info="$(grep -h "${sso_url}" ~/.aws/sso/cache/*)"
        local expiration="$(<<<$sso_info jq -cr '.expiresAt' | tr -d ':TZ\-')"

        [ "${expiration}" -gt "${now}" ] || {
            aws sso login --profile "${profile_name}"
            local sso_info="$(grep -h "https://cubesatdata.awsapps.com/start#/" ~/.aws/sso/cache/*)"
        }

        local token="$(<<<$sso_info jq -cr .accessToken)"

        local creds="$(aws sso get-role-credentials --profile "${profile_name}" \
            --access-token "${token}" \
            --role-name "${role_name}" \
            --account-id "${account_id}")"
        export AWS_ACCESS_KEY_ID="$(<<<$creds jq -cr '.roleCredentials.accessKeyId')"
        export AWS_SECRET_ACCESS_KEY="$(<<<$creds jq -rc '.roleCredentials.secretAccessKey')"
        export AWS_SESSION_TOKEN="$(<<<$creds jq -rc '.roleCredentials.sessionToken')"
    else
        local identity="$(aws sts get-caller-identity --profile "${profile_name}")"
        local user_id="$(<<<$identity jq -cr '.UserId')"
        local creds="$(grep -h "${user_id}" ~/.aws/cli/cache/*)"
        export AWS_ACCESS_KEY_ID="$(<<<$creds jq -cr '.Credentials.AccessKeyId')"
        export AWS_SECRET_ACCESS_KEY="$(<<<$creds jq -rc '.Credentials.SecretAccessKey')"
        export AWS_SESSION_TOKEN="$(<<<$creds jq -rc '.Credentials.SessionToken')"
    fi

    export AWS_DEFAULT_REGION=${region}
    export AWS_REGION=${region}
}
