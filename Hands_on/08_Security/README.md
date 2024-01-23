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

# Pod Security Standards

    Create a new namespace called example:
    ```
    kubectl create ns example
    ```
    The output is similar to this:
    ```
    namespace/example created
    ```
    Execute below command:
    ```
    kubectl label --overwrite ns example \
        pod-security.kubernetes.io/warn=baseline \
        pod-security.kubernetes.io/warn-version=latest
    ```
    Execute below command:
    ```
    kubectl label --overwrite ns example \
        pod-security.kubernetes.io/enforce=baseline \
        pod-security.kubernetes.io/enforce-version=latest \
        pod-security.kubernetes.io/warn=restricted \
        pod-security.kubernetes.io/warn-version=latest \
        pod-security.kubernetes.io/audit=restricted \
        pod-security.kubernetes.io/audit-version=latest
    ```
    Create a baseline Pod in the example namespace:
    ```
    kubectl apply -n example -f https://k8s.io/examples/security/example-baseline-pod.yaml
    ```
    The Pod does start OK; the output includes a warning. For example:
    ```
    Warning: would violate PodSecurity "restricted:latest": allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or container "nginx" must set securityContext.runAsNonRoot=true), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
    pod/nginx created
    ```
    Create a baseline Pod in the default namespace:
    ```
    kubectl apply -n default -f https://k8s.io/examples/security/example-baseline-pod.yaml
    ```
    Output is similar to this:
    ```
    pod/nginx created
    ```
    The Pod Security Standards enforcement and warning settings were applied only to the example namespace. You could create the same Pod in the default namespace with no warnings.

17.  Clean your environment
    ```
    ./delete.sh
    ```