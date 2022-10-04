# deploy-action
Github Action to triggers a deployment workflow

### How to use in action

```yaml
- uses: thinkei/deploy-action@v1.0.0
  with:
    app_name: sbx-eng
    image_name: ehdevops/example:1.0.0
    cluster_context: staging
    author: eh-bot
    trigger_deploy: true
    wait_deploy: false
    deploy_token: ${{ github.token }}
    wait_interval: 30
```


## Setup development environment
### prepare environment
```
cat > .env <<EOF
INPUT_APP_NAME=sbx-eng
INPUT_IMAGE_NAME=ehdevops/example:1.0.0
INPUT_CLUSTER_CONTEXT=staging
INPUT_AUTHOR=eh-bot
INPUT_TRIGGER_DEPLOY=true
INPUT_WAIT_DEPLOY=true
INPUT_DEPLOY_TOKEN=<github-token>
INPUT_WAIT_INTERVAL=3
EOF
```
### bump-it development
```sh
docker-compose up
```

## License
Copyright 2022

