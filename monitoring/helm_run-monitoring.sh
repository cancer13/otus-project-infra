#!/bin/zsh/
export SLACK_WEBHOOK="$(cat slack_webhook.key)"

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
    -f values-kube-prometheus-stack.yaml \
    --set alertmanager.config.global.slack_api_url=$SLACK_WEBHOOK \
    -n monitoring \
    --create-namespace \
    --version="41.9.1" \
    --timeout 10m