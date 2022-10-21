#!/usr/bin/env bash
set -e

usage_docs() {
  echo ""
  echo "You can use this Github Action with:"
  echo "- uses: thinkei/eh-deploy-action"
  echo "  with:"
  echo "    app_name: employment-hero"
  echo "    image_name: ehdevops/example:1.0.0"
  echo "    cluster_context: staging"
  echo "    author: tbd"
  echo "    trigger_deploy: true"
  echo "    wait_deploy: false"
  echo "    deploy_token: \${{ secrets.DEPLOY_TOKEN }}"
  echo "    wait_interval: 30"

}
API_STG="hero2.staging.ehrocks.com:443"
API_INT="hero2.integration.ehrocks.com:443"
API_PROD="hero2.ehrocks.com:443"

_validate_args() {

  if [ -z "${INPUT_APP_NAME}" ]
  then
    echo "Error: app_name is a required argument."
    usage_docs
    exit 1
  fi

  if [ -z "${INPUT_IMAGE_NAME}" ]
  then
    echo "Error: image_name is a required argument."
    usage_docs
    exit 1
  fi

  if [ -z "${INPUT_CLUSTER_CONTEXT}" ]
  then
    echo "Error: cluster_context is required"
    usage_docs
    exit 1
  fi

  if [ -z "${INPUT_AUTHOR}" ]
  then
    INPUT_AUTHOR="GithubCI"
  fi

  if [ -z "${INPUT_TRIGGER_DEPLOY}" ]
  then
    echo "Error: trigger_deploy is required"
    usage_docs
    exit 1
  fi


  if [ -z "${INPUT_WAIT_DEPLOY}" ]
  then
    INPUT_WAIT_DEPLOY="false"
  fi

  if [ -z "${INPUT_DEPLOY_TOKEN}" ]
  then
    echo "Error: deploy_token is required"
    usage_docs
    exit 1
  fi

  if [ -z "${INPUT_WAIT_INTERVAL}" ]
  then
    INPUT_WAIT_INTERVAL=30
  fi

}

_lets_wait() {
  echo "Sleeping for ${INPUT_WAIT_INTERVAL} seconds"
  sleep $INPUT_WAIT_INTERVAL
}

_gen_token() {
  if [ "${INPUT_CLUSTER_CONTEXT}" = "staging" ]
  then
    eval "$(herocli --server ${API_STG} login ${INPUT_DEPLOY_TOKEN} | tail -1 | xargs )"
  elif [ "${INPUT_CLUSTER_CONTEXT}" = "integration" ]
  then
    eval "$(herocli --server ${API_INT} login ${INPUT_DEPLOY_TOKEN} | tail -1 | xargs )"
  elif [ "${INPUT_CLUSTER_CONTEXT}" = "production" ]
  then
    eval "$(herocli --server ${API_PROD} login ${INPUT_DEPLOY_TOKEN} | tail -1 | xargs )"
  fi
}


_deploy() {
  if [ "${INPUT_CLUSTER_CONTEXT}" = "staging" ]
  then
    herocli --server ${API_STG} app deploy ${INPUT_APP_NAME} --image ${INPUT_IMAGE_NAME} --user ${INPUT_AUTHOR}
  elif [ "${INPUT_CLUSTER_CONTEXT}" = "integration" ]
  then
    herocli --server ${API_INT} app deploy ${INPUT_APP_NAME} --image ${INPUT_IMAGE_NAME} --user ${INPUT_AUTHOR}
  elif [ "${INPUT_CLUSTER_CONTEXT}" = "production" ]
  then
    herocli --server ${API_PROD} app deploy ${INPUT_APP_NAME} --image ${INPUT_IMAGE_NAME} --user ${INPUT_AUTHOR}
  fi  
}


_get_deployment_status() {
  server=$1
  herocli --server ${server} app deployment-status ${INPUT_APP_NAME} | grep "Deployment status" | awk '{print $3}'
}

_wait_for_deploy_to_finsh() {
  STATUS="NULL"
  if [ "${INPUT_CLUSTER_CONTEXT}" = "staging" ]
  then
    while ! [[ "${STATUS}" =~ "Success" ]]
    do
      _lets_wait
      STATUS=$(_get_deployment_status "${API_STG}")
    done
  elif [ "${INPUT_CLUSTER_CONTEXT}" = "integration" ]
  then
    while ! [[ "${STATUS}" =~ "Success" ]]
    do
      _lets_wait
      STATUS=$(_get_deployment_status "${API_INT}")
    done
  elif [ "${INPUT_CLUSTER_CONTEXT}" = "production" ]
  then
    while ! [[ "${STATUS}" =~ "Success" ]]
    do
      _lets_wait
      STATUS=$(_get_deployment_status "${API_PROD}")
    done
  fi  
}

main() {
  _validate_args
  _gen_token

  if [ "${INPUT_TRIGGER_DEPLOY}" = true ]
  then
    _deploy
  else
    echo "Skipping triggering the deployment."
  fi

  if [ "${INPUT_WAIT_DEPLOY}" = true ]
  then
      _wait_for_deploy_to_finsh
  else
    echo "Skipping waiting for deployment."
  fi
}

main
