#!/bin/bash
# shellcheck disable=SC2219,SC2034

PRJ_ROOT_PATH="${SDPATH}/.."
readonly PRJ_ROOT_PATH="$(cd "${PRJ_ROOT_PATH}" && pwd)"

readonly NPROC=$(nproc)
