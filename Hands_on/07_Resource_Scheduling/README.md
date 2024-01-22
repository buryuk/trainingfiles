1. Create a ResourceQuota with CPU and memory requests and limits
    ```
    kubectl create -f 01_01_mem-cpu-quota.yaml
    ```
2. Confirm the quota was created
    ```
    kubectl describe quota mem-cpu-quota
    ```
3. Create a new “php-apache” deployment
    ```
    kubectl create -f 01_02_php-apache.yaml
    ```
4. Once the Deployment has been created, check it’s status
    ```
    kubectl describe deployment php-apache
    kubectl get pods
    ```
    Note: There is no pod created. Because of no resource limit defined

5. Add Deployment Resources
    ```
    kubectl apply -f 01_03_php-apache.yaml
    ```
6. What is the Deployment and Pod status now?
    ```
    kubectl describe deployment php-apache
    kubectl get pods
    ```

7. Woohoo, a Pod! Now let’s scale up our deployment to 10 replicas
    ```
    kubectl scale deploy php-apache --replicas=10
    kubectl rollout status deploy php-apache
    kubectl get pods
    ```
8.  Why only 1 pod? How can we get our deployment to scale up?
    ```
    kubectl describe deployment php-apache
    kubectl get events
    kubectl describe quota mem-cpu-quota
    ```
9. It is because ResourceQuota
    ```
    kubectl scale deploy php-apache --replicas=2
    kubectl delete quota mem-cpu-quota
    ```
10. Add a Horizontal Pod Autoscaler to your “php-apache” deployment
    ```
    kubectl create -f 02_02_php-apache-hpa.yaml
    ```
11. Check if it is created
    ```
    kubectl get hpa
    ```
12. Run this in a separate terminal so that the load generation continues and you can carry on with the rest of the steps:
    ```
    kubectl run load-generator --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"
    ```
    We deployed a killer application :)
    Within a minute or so, you should see the higher CPU load
    ```
    kubectl get hpa php-apache-hpa --watch
    ```
    or
    ```
    kubectl get hpa php-apache
    ```
13. The Deployment was resized
    ```
    kubectl get deployment php-apache
    ```
14. Stop generating load
    ```
    kubectl delete pod load-generator
    ```

15. Then verify the result state (after a minute or so):
    ```
    kubectl get hpa php-apache-hpa --watch # type Ctrl+C to end the watch when you're ready
    kubectl get hpa php-apache-hpa
    ```
16. Clean your environment
    ```
    ./delete.sh
    ```