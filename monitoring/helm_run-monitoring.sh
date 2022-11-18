#!/bin/zsh/
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
    -f values-kube-prometheus-stack.yaml \
    -n monitoring \
    --create-namespace
