export TMPDIR=${TMPDIR:-/tmp}

load_config() {
    local config_path=$TMPDIR/rclone_config
    local rclone_config_path=/opt/rclone/config
    local rclone_config_file=$rclone_config_path/.rclone.conf

    (jq -r '.source.config // empty' < $1) > $config_path

    if [ -s $config_path ]; then
        mkdir -p $rclone_config_path
        mv $config_path $rclone_config_file
        # TODO: Remove Me - DEBUGGING
        echo "Config file:"
        cat $rclone_config_file
        chmod 500 $rclone_config_file
    else
        echo "No config provided"
        exit 1
    fi
}

load_files() {
    set +e
    local files=$(jq -r '.source.files | keys | join(" ") // ""' < $1) 2> /dev/null
    set -e
    # TODO: Remove Me - DEBUGGING
    echo "Files:"
    echo $files
    for fileName in files; do
        local jq_path=".source.files.${fileName}"
        local content=$(jq -r "${jq_path}" < $1)
        echo "$content" > "/tmp/${fileName}"
        # TODO: Remove Me - DEBUGGING
        echo "File /tmp/${fileName}"
        cat /tmp/${fileName}
    done
}