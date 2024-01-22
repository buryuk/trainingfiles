1. Create a deployment with default configuration
    ```
    kubectl create -f front-end-deploy-def.yaml
    ```
2. Check the Deployment
    ```
    kubectl get deploy
    ```
3. Check the ReplicaSet
    ```
    kubectl get rs
    ```
4. Check default StrategyType of the deployment as RollingUpdate

    Check default RollingUpdateStrategy:  25% max unavailable, 25% max surge
    ```
    kubectl describe deploy front-end-deploy
    ```
5. Update the image of deployment
    ```
    kubectl set image deployment/front-end-deploy-def front-end-deploy-container=nginx:1.21
    ```
6. Check deployment steps
    ```
    kubectl rollout status deployment front-end-deploy-def
    ```
    or below:
    ```
    watch kubectl get pod -o custom-columns="POD-NAME":.metadata.name,"POD-STATUS":.status.phase,"POD-IMAGES":.spec.containers[*].image
    ```
7. Check the different ReplicaSets
    ```
    kubectl get rs
    ```
8. Check the rollout history
    ```
    kubectl rollout history deploy front-end-deploy-def
    ```
9. Rollback to previous revision
    ```
    kubectl rollout undo deploy front-end-deploy-def
    ```
10. Rollback to specific revision
    ```
    kubectl rollout undo deploy front-end-deploy-def --to-revision=2
    ```
11. Create a deployment with Recreate strategy
    ```
    kubectl create -f front-end-deploy-recreate.yaml

12. Update the image of deployment
    ```
    kubectl set image deployment/front-end-deploy-recreate front-end-deploy-container=nginx:1.22
    ```
    See all existing Pods are killed before new ones are created

13. Clean your environment
    ```
    ./delete.sh
    ```