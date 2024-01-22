#!/usr/bin/env bash

kubectl delete -f 01_03_php-apache.yaml
kubectl delete -f 02_02_php-apache-hpa.yaml
kubectl delete pod load-generator