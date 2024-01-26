
1. Create the environment with two deployments
    ```
    kubectl create -f First_Deployment/web-deploy.yaml
    kubectl create -f First_Deployment/web-svc.yaml
    kubectl create -f Second_Deployment/web2-deploy.yaml
    kubectl create -f Second_Deployment/web2-svc.yaml
    ```
2. Create an Ingress Fanout
    ```
    kubectl create -f fanout-ingress.yaml
    ```
3. View the Rules section and check Backends
    ```
    kubectl describe ingress fanout-ingress
    ```
4. Test Ingress endpoints
    Check Ingress external IP
    ```
    kubectl get ingress
    ```
    It takes 5-10 minutes, GCP to create a Load Balancer and show its IP and started to serve.
    When it is ready, take IP address from ADDRESS column.
    ```
    curl --connect-timeout 5 http://<Your IP address>/
    curl --connect-timeout 5 http://<Your IP address>/v2/
    ```
    For example:
    ```
    curl --connect-timeout 5 http://34.49.68.133/
    curl --connect-timeout 5 http://34.49.68.133/v2/
    ```
    You should have below output as similiar:
    ```
    Hello, world!
    Version: 1.0.0
    Hostname: web-58756b54cc-lppjn
    ```
    ```
    Hello, world!
    Version: 2.0.0
    Hostname: web2-58f57dc448-vmwws
    ```

5. Clean your environment
    ```
    ./delete.sh
    ```
