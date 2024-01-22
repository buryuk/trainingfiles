#!/usr/bin/env bash

kubectl delete -f First_Deployment
kubectl delete -f Second_Deployment
kubectl delete -f fanout-ingress.yaml
