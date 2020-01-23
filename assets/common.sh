#!/usr/bin/bash
export TMPDIR=${TMPDIR:-/tmp/rclone}
mkdir -p "${TMPDIR}"

load_config() {
    RCLONE_CONFIG=$TMPDIR/.config/rclone_config
    export RCLONE_CONFIG

    (jq -r '.source.config // empty' < "$1") > "$RCLONE_CONFIG"
    config_pass=$(jq -r '.source.password // ""' < "$1")

    if [[ -n "${config_pass}" ]]; then
        RCLONE_CONFIG_PASS="${config_pass}"
        export RCLONE_CONFIG_PASS
    fi

    if [ -s "${RCLONE_CONFIG}" ]; then
        chmod 500 "${RCLONE_CONFIG}"
    else
        echo "No config provided"
        exit 1
    fi
}

load_files() {
    set +e

    local files
    files=$(jq -r '.source.files? | keys? | join(" ") // ""' < "$1")
    
    set -e
    if [[ -n "${files}" ]]; then
        for fileName in $files; do
            local jq_path
            local content
            jq_path=".source.files.${fileName}"
            content=$(jq -r "${jq_path}" < "$1")
            echo "$content" > "${TMPDIR}/${fileName}"
            echo "Wrote: ${TMPDIR}/${fileName}"
        done
        ls -alh "${TMPDIR}"
    fi
}