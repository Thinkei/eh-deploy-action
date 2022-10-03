#!/usr/bin/env bash
set -e

usage_docs() {
  echo ""
  echo "You can use this Github Action with:"
  echo "- uses: thinkei/deploy-action"
  echo "  with:"
  echo "    app_name: employment-hero"
  echo "    image_name: ehdevops/example:1.0.0"
  echo "    cluster_context: staging"
  echo "    author: tbd"
  echo "    check: false"
}

validate_args() {
  app_name=employment-hero
  if [ "${INPUT_APP_NAME}" ]
  then
    range=${INPUT_APP_NAME}
  fi
}


main() {
  validate_args


}

main
