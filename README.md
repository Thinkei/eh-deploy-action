# deploy-action
Github Action to triggers a deployment workflow

## Arguments

| Argument Name            | Required   | Default     | Description           |
| ---------------------    | ---------- | ----------- | --------------------- |
| `app_name` | True|  | Application deployment|
| `image_name`| True| | Container image url |
| `cluster_context`| True |  | Cluster context `<staging>/<intergration>/<production>` |
| `author` | False | `GithubCI`| Author of deployment |
| `trigger_deploy` | True |  | Trigger deployment |
| `wait_deploy` | False | `false` | Check deployment is totally rolled out |
| `deploy_token` | True | | Token of deployment |
| `wait_interval` | False | `30` | The number of seconds delay between checking for result of run.|


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
    deploy_token: ${{ secrets.DEPLOY_TOKEN }}
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

