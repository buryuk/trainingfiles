1. Create a pod with Readiness and Liveness probes
    ```
    kubectl create -f front-end-pod-http.yaml
    ```
2. Check the probe (Containers > front-end-container > Liveness and Readiness)
    ```
    kubectl describe po front-end-pod
    ```
3. Create a pod with Readiness and Liveness probes
    ```
    kubectl create -f front-end-pod-tcp.yaml
    ```
    Check it is using port name instead of port number

4. Create a pod with an exec
    ```
    kubectl create -f front-end-pod-exec.yaml
    ```
5. Create a pod with StartupProbe
    ```
    kubectl create -f front-end-pod-start.yaml
    ```
6. Check its timing
    ```
    kubectl get pods -w
    ```
7. Clean your environment
    ```
    ./delete.sh
    ```