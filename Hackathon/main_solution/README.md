1. Create a Secret for database
    ```
    kubectl create -f 01_db-secret.yml
    ```

2. Create a Mongo database
    ```
    kubectl create -f 02_db-deploy.yml
    ```

3. Create application
    Application needs to have limits for load generation
    ```
    kubectl create -f 03_app-deploy.yml
    ```

4. Create data in database with Mongo Seed
    ```
    kubectl create -f 04_mongo-seed-job.yml
    ```

5. Create a Horizontal Pod Autoscaler
    ```
    kubectl create -f 05_hpa-deploy.yml
    ```
    Create a load to app
    ```
    kubectl run load-generator --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://api-app; done"
    ```
    After one minute, another pod will be created.
    HPA can be checked with below command
    ```
    k get hpa
    ```
    You should have below output
    ```
    NAME          REFERENCE            TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    hpa-api-app   Deployment/api-app   44%/10%   1         10        9          3m4s
    ```

6. Create a Promethues Service Monitor to monitor API app
    Create a Service Monitor
    ```
    kubectl create -f 06_svc_monitor.yml
    ```
    After some time, you should see it in Prometheus
    Prometheus can be reached by below command:
    ```
    kubectl port-forward svc/prometheus-operated 9090:9090 -n monitoring
    ```
    From your browser go to localhost:9090
    Go Status > Targets
    You will see serviceMonitor/monitoring/api-app