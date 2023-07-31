#!/bin/bash

set -eu
set -o pipefail

SDPATH="$(dirname "${BASH_SOURCE[0]}")"
if [[ ! -d "${SDPATH}" ]]; then SDPATH="${PWD}"; fi
readonly SDPATH="$(cd "${SDPATH}" && pwd)"

cd "${SDPATH}"; echo + cd "${PWD}"

# shellcheck source=./conf.sh
source "${SDPATH}/conf.sh"

CMD=(git submodule update --init --recursive "--jobs=${NPROC}")
echo + "${CMD[@]}" && "${CMD[@]}"
