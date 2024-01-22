#!/usr/bin/env bash

kubectl delete -f front-end-deploy-def.yaml
kubectl delete -f front-end-deploy-recreate.yaml
