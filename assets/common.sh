#!/usr/bin/bash
export TMPDIR=${TMPDIR:-/tmp}

load_config() {
    local config_path=$TMPDIR/rclone_config
    local rclone_config_path=/opt/rclone/config
    local rclone_config_file=$rclone_config_path/.rclone.conf

    (jq -r '.source.config // empty' < "$1") > "$config_path"
    config_pass=$('.source.password // ""' < "$1")

    if [[ -n "${config_pass}" ]]; then
        RCLONE_CONFIG_PASS="${config_pass}"
        export RCLONE_CONFIG_PASS
    fi

    if [ -s "$config_path" ]; then
        mkdir -p $rclone_config_path
        mv "$config_path" $rclone_config_file
        chmod 500 $rclone_config_file
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