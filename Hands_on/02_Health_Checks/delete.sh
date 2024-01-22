#!/usr/bin/env bash

kubectl delete -f front-end-pod-http.yaml
kubectl delete -f front-end-pod-tcp.yaml
kubectl delete -f front-end-pod-exec.yaml
kubectl delete -f front-end-pod-start.yaml