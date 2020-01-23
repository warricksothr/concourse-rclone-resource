#!/usr/bin/env bash

TEAM=docker
PIPELINE=concourse-rclone-resource

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd "${DIR}" || exit

fly -t ${TEAM} set-pipeline --pipeline ${PIPELINE} --config pipeline.yml

popd || exit
