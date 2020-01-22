export TMPDIR=${TMPDIR:-/tmp}

load_config() {
    local config_path=$TMPDIR/rclone_config

    (jq -r '.source.config // empty' < $1) > $config_path

    if [ -s $config_path ]; then
        mkdir -p /opt/rclone/config
        mv $config_path > /opt/rclone/config/.rclone.conf
        chmod 500 /opt/rclone/config/.rclone.conf
    else
        echo "No config provided"
        exit 1
    fi
}

load_files() {
    local files=$(jq -r '.source.files | keys | join(" ")' < $1)
    for fileName in files; do
        local jq_path=".source.files.${fileName}"
        local content=$(jq -r "${jq_path}" < $1)
        echo "$content" > "/tmp/${fileName}"
    done
}