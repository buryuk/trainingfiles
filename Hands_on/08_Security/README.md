# Authentication

1. See default ServiceAccount
    ```
    kubectl get sa
    ```
2. Create a deployment
    ```
    kubectl create deployment nginx --image=nginx
    ```
    Starts a single instance of nginx
3. See default serviceaccount mount
    ```
    kubectl exec nginx-76d6c9b8c-4jkf4 -it -- sh -c 'ls -l /var/run/secrets/kubernetes.io/serviceaccount'
    ```
    Your Nginx pod name will be different. Change the above code with your Nginx pod name.
4. See default serviceaccount token
    ```
    kubectl exec nginx-76d6c9b8c-4jkf4 -it -- sh -c 'cat /var/run/secrets/kubernetes.io/serviceaccount/token'
    ```
    Aha! It is here:
    ```
    lrwxrwxrwx 1 root root 12 Jan 19 17:37 token -> ..data/token
    ```

# Authorization

5. Create a ServiceAccount
    ```
    kubectl create -f 02_01_service-account.yaml
    ```
6. Check if new service account can get pods
    ```
    kubectl auth can-i get pods --as=system:serviceaccount:default:myaccount
    ```
    Output should be like: no

7. Create a Role and RoleBinding for new ServiceAccount
    ```
    kubectl create -f 02_02_scenario2.yaml
    ```
8. Check the Role and RoleBinding
    ```
    kubectl get roles
    kubectl get rolebindings
    ```
9. Check if new service account can get pods
    ```
    kubectl auth can-i get pods --as=system:serviceaccount:default:myaccount
    ```
    Output should be like: yes
10. Check your "myaccount" can see pods from inside of a test pod
    ```
    kubectl run test-kubectl --image=bitnami/kubectl:latest --overrides='{ "spec": { "serviceAccount": "myaccount" }  }' -- get pods
    kubectl logs test-kubectl
    ```
    Output:
    ```
    NAME                     READY   STATUS      RESTARTS   AGE
    nginx-77b4fdf86c-nmpjh   1/1     Running     0          5m36s
    test-kubectl             0/1     Completed   0          3s
    ```

17.  Clean your environment
    ```
    ./delete.sh
    ```