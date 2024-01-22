1. Check if kubectl works and if it can connect to the cluster
    ```
    kubectl cluster-info
    ```
2. What kubectl version do you use?
    ```
    kubectl version --short
    ```
3. What version of Kubernetes is used on the cluster?
    ```
    kubectl get nodes
    ```
4. What is the number and size of the worker nodes?
    ```
    kubectl get nodes
    kubectl describe nodes
    ```
    Look for 'Capacity' section

5. What are the allocatable resources on nodes?
    ```
    kubectl describe nodes
    ```
    Look for 'Allocatable' section

6. Create a namespace

    ```
    kubectl create namespace <your-first-name>
    ```

7. Set this namespace as default

    ```
    kubectl config set-context --current --namespace=<your-first-name>
    ```

8. What namespaces are available on the cluster?
    ```
    kubectl get namespaces
    ```
9. Create ConfigMap and check
    ```
    kubectl create -f front-end-cm.yaml
    kubectl get cm
    ```
10. Create Secret
    ```
    kubectl create -f front-end-secret.yaml
    ubectl get secrets
    ```
11. Create Pod
    ```
    kubectl create -f front-end-pod.yaml
    kubectl get po
    ```
12. Create Service
    ```
    kubectl create -f front-end-service.yaml
    kubectl get svc
    ```
13. Check connection to service
    ```
    kubectl run test-curl --image=curlimages/curl --restart=Never --rm -it -- sh -c 'curl --connect-timeout 5 front-end-service'
    ```
14. Check what is inside of ConfigMap
    ```
    kubectl describe configmaps front-end-cm
    ```
15. Check what is inside of Secret
    ```
    kubectl exec front-end-pod -it -- sh -c 'echo $SECRET_USERNAME'
    kubectl get secret front-end-secret -o jsonpath='{.data.password}' | base64 --decode
    ```
16. Clean your environment
    ```
    ./delete.sh
    ```