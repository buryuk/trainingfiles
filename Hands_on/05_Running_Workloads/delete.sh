#!/usr/bin/env bash

kubectl delete -f statefulset.yaml
kubectl delete -f sts-svc.yaml
kubectl delete pvc www-web-0 www-web-1
kubectl delete -f daemonset.yaml
kubectl delete -f job.yaml
kubectl delete -f cronjob.yaml
kubectl delete -f ../04_Exposing_Services/First_Deployment
kubectl delete -f ../04_Exposing_Services/Second_Deployment
kubectl delete -f initcontainer.yaml
kubectl delete -f sidecar.yaml
helm uninstall myhelloworld