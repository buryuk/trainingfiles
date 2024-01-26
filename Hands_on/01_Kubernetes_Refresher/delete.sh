#!/usr/bin/env bash

kubectl delete -f front-end-cm.yaml
kubectl delete -f front-end-secret.yaml
kubectl delete -f front-end-pod.yaml
kubectl delete -f front-end-service.yaml