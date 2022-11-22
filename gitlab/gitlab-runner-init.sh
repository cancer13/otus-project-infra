#!/bin/zsh
GITLAB_RUNNER_TOKEN="$(echo register_token.key)"

helm upgrade --install gitlab-runner gitlab/gitlab-runner \
    --set runnerRegistrationToken="$GITLAB_RUNNER_TOKEN" \
    -f gitlab-runner-values.yaml \
    -n gitlab-runner \
    --create-namespace

kubectl apply -f gitlab-admin-service-account.yaml
