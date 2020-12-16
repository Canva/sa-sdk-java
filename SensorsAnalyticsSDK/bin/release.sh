#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "${REPO_ROOT}"

SENSORS_HOME="${REPO_ROOT}/SensorsAnalyticsSDK"

main() {

  cd "${SENSORS_HOME}"

  if [[ -z "${!S3_REPOSITORY_URL:-}" ]]; then
    error "S3_REPOSITORY_URL not set"
  fi

  echo "--- Deploying maven artifact to S3"
  mvn \
    --quiet \
    --settings "${SENSORS_HOME}/settings.xml" \
    clean deploy

  echo "--- Success"
}

main "$@"
