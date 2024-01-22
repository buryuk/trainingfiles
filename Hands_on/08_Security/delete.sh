#!/usr/bin/env bash

kubectl delete -f 02_01_service-account.yaml
kubectl delete -f 02_02_scenario2.yaml
kubectl delete deploy nginx
kubectl delete po test-kubectl