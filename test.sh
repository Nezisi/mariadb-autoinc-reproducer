#!/usr/bin/env bash
set -o errexit
set -o nounset

script_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
sql_dir="${script_dir}/sql"

set -a
MARIADB_DATABASE="test"
MARIADB_USER="test"
MARIADB_PASSWORD="test"
set +a

MARIADB_VERSIONS=("10.6.15" "10.11.4" "10.11.5")

printf "Script dir: %s\n" "${script_dir}"
for mariadb_version in "${MARIADB_VERSIONS[@]}"; do
    file_path="${sql_dir}/test.sql"
    file_name=$(basename "${file_path}")
    tag_name="testcontainer:${mariadb_version}"


    printf "File name: '%s', MariaDB Version: '%s'\n" "${file_name}" "${mariadb_version}"

    docker_build_args=()
    docker_build_args+=("--quiet")
    docker_build_args+=("--pull" "--no-cache" "--tag=${tag_name}")
    docker_build_args+=("--build-arg" "MARIADB_DATABASE=${MARIADB_DATABASE}")
    docker_build_args+=("--build-arg" "MARIADB_USER=${MARIADB_USER}")
    docker_build_args+=("--build-arg" "MARIADB_PASSWORD=${MARIADB_PASSWORD}")
    docker_build_args+=("--build-arg" "MARIADB_VERSION=${mariadb_version}")
    docker_build_args+=("--build-arg" "SQL_FILE=${file_name}")

    if ! docker build "${docker_build_args[@]}" "${script_dir}"; then
        printf "Building docker image for file '%s' failed.\n" "${file_name}" >&2
        exit 1
    fi

    printf "Build docker image: '%s'\n" "${tag_name}"
    if ! docker run --detach --name="testcontainer" "${tag_name}"; then
        printf "Cannot start test container.\n" >&2
        exit 1
    fi

    printf "sleeping 5 secs for container start\n"
    sleep 5

    mariadb_command=()
    mariadb_command+=("mariadb")
    mariadb_command+=("--user=${MARIADB_USER}" "--password=${MARIADB_PASSWORD}")
    mariadb_command+=("--execute=SHOW CREATE TABLE test.pcfeature")

    if ! docker exec "testcontainer" "${mariadb_command[@]}"; then
        printf "Cannot execute test container command.\n" >&2
    fi


    if ! docker rm --force "testcontainer"; then
        printf "Cannot stop test container.\n" >&2
        exit 1
    fi
done
