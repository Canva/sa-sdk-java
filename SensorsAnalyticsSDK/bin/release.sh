#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "${REPO_ROOT}"

SENSORS_HOME="${REPO_ROOT}/SensorsAnalyticsSDK"
SNAPSHOT_HOME="${SENSORS_HOME}/target/snapshot"

main() {

  cd "${SENSORS_HOME}"

  if [[ -z "${S3_REPOSITORY_URL:-}" ]]; then
    echo "S3_REPOSITORY_URL not set"
    exit 1
  fi

  echo "--- Building artifacts"

  rm -rf "${SNAPSHOT_HOME}"

  mvn \
    deploy \
    -DaltDeploymentRepository=snapshot-repo::default::file:target/snapshot

  echo "--- Deploying maven artifact to S3"

  aws s3 cp \
    "${SNAPSHOT_HOME}" \
    "${S3_REPOSITORY_URL}" \
    --recursive \
    --exclude "**/*/maven-metadata.xml*"

  echo "--- Success"
}

main "$@"
