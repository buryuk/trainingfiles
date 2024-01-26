#!/usr/bin/env bash

kubectl delete -f front-end-deploy.yaml
kubectl delete servicemonitor front-end -n monitoring