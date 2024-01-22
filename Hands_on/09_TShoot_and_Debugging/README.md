1. Create broken deploy-1
    ```
    kubectl create -f 11_broken_deploy-1.yaml
    ```
    Tip: check probe configuration

    Fix the deploy-1
    ```
    kubectl apply -f 12_fix_deploy-1.yaml
    ```
2.  Create broken deploy-2
    ```
    kubectl create -f 13_broken-deploy-2.yaml
    ```
    Tip: check probe configuration

    Fix the deploy-2
    ```
    kubectl apply -f 14_fix-deploy-2.yaml
    ```
    Clean-up
    ```
    kubectl delete deploy deploy-1 deploy-2
    ```
3. Create broken service my-nginx
    ```
    kubectl create -f 15_broken_svc-1.yaml
    ```
    Service cannot be reachable
    ```
    kubectl run test-curl --image=curlimages/curl --restart=Never --rm  -it -- sh -c 'curl --connect-timeout 5 my-nginx'
    ```
    Tip: Check Service configuration
    Fix the my-ginx
    ```
    kubectl apply -f 15_fix_svc-1.yaml
    ```
    Service should be reachable
    ```
    kubectl run test-curl --image=curlimages/curl --restart=Never --rm  -it -- sh -c 'curl --connect-timeout 5 my-nginx'
    ```

4. Create second broken service
    ```
    kubectl create -f 16_broken_svc-2.yaml
    ```
    Service cannot be reachable
    ```
    kubectl run test-curl --image=curlimages/curl --restart=Never --rm  -it -- sh -c 'curl --connect-timeout 5 my-nginx-2'
    ```
    Tip: Check the pods are healthy

    Fix the my-ginx-2
    ```
    kubectl apply -f 16_fix_svc-2.yaml
    ```
    Service can be reachable
    ```
    kubectl run test-curl --image=curlimages/curl --restart=Never --rm  -it -- sh -c 'curl --connect-timeout 5 my-nginx-2'
    ```

5. Create a broken pod with initContainer
    ```
    kubectl create -f 01_initcontainer.yaml
    ```
    Delete the pod and create it with correct service name in the init container command.

    Clean up
    ```
    kubectl delete po myapp-pod
    ```
6. Create a pod with ErrImagePull error
    ```
    kubectl create -f 03_errimagepull-error.yaml
    ```
    Fix the image name and re-create the pod
    Clean up
    ```
    kubectl delete pod errimagepull-error
    ```
7. Create a pod with changing error
    ```
    kubectl create -f 05_weird-behavior.yaml
    ```
    Fix the sleep command and re-create the pod
    Clean up
    ```
    kubectl delete po weird-behavior
    ```
8. Create a broken pod
    ```
    kubectl create -f 06_broken-pod-1.yaml
    ```
    Tip: Check if volume exists
    Clean up
    ```
    kubectl delete po broken-pod-1
    ```
9. Create a broken pod
    ```
    kubectl create -f 07_run-container-error.yaml
    ```
    Check the command inside of the container
    Clean up
    ```
    kubectl delete po run-container-error
    ```
10. You can use the kubectl debug command to add ephemeral containers to a running Pod. First, create a pod for the example:
    ```
    kubectl run ephemeral-demo --image=registry.k8s.io/pause:3.1 --restart=Never
    ```
    The examples in this section use the pause container image because it does not contain debugging utilities, but this method works with all container images.
    If you attempt to use kubectl exec to create a shell you will see an error because there is no shell in this container image.
    ```
    kubectl exec -it ephemeral-demo -- sh
    ```
    Output:
    ```
    OCI runtime exec failed: exec failed: container_linux.go:346: starting container process caused "exec: \"sh\": executable file not found in $PATH": unknown
    ```
    You can instead add a debugging container using kubectl debug. If you specify the -i/--interactive argument, kubectl will automatically attach to the console of the Ephemeral Container.
    ```
    kubectl debug -it ephemeral-demo --image=busybox:1.28 --target=ephemeral-demo
    ```
    You can view the state of the newly created ephemeral container using kubectl describe:
    ```
    kubectl describe pod ephemeral-demo
    ```
    Use kubectl delete to remove the Pod when you're finished:
    ```
    kubectl delete pod ephemeral-demo
    ```
11. Debugging using a copy of the Pod
    ```
    kubectl run myapp --image=busybox:1.28 --restart=Never -- sleep 1d
    ```
    Copying a Pod while adding a new container
    Run this command to create a copy of myapp named myapp-debug that adds a new Ubuntu container for debugging:
    ```
    kubectl debug myapp -it --image=ubuntu --share-processes --copy-to=myapp-debug
    ```
    Clean up
    ```
    kubectl delete pod myapp myapp-debug
    ```
12. Copying a Pod while changing its command
    ```
    kubectl run --image=busybox:1.28 myapp -- false
    ```
    You can use kubectl debug to create a copy of this Pod with the command changed to an interactive shell:
    ```
    kubectl debug myapp -it --copy-to=myapp-debug --container=myapp -- sh
    ```
    Clean up
    ```
    kubectl delete pod myapp myapp-debug
    ```
12. Copying a Pod while changing container images
    ```
    kubectl run myapp --image=busybox:1.28 --restart=Never -- sleep 1d
    ```
    Now use kubectl debug to make a copy and change its container image to ubuntu:
    ```
    kubectl debug myapp --copy-to=myapp-debug --set-image=*=ubuntu
    ```
    Clean up
    ```
    kubectl delete pod myapp myapp-debug
    ```
13. Create a pod
    ```
    kubectl create -f 08_shell-demo.yaml
    ```
    Verify that the container is running:
    ```
    kubectl get pod shell-demo
    ```
    Get a shell to the running container:
    ```
    kubectl exec --stdin --tty shell-demo -- /bin/bash
    ```
    You can run these example commands inside the container
    ```
    ls /
    cat /proc/mounts
    cat /proc/1/maps
    apt-get update
    apt-get install -y tcpdump
    tcpdump
    apt-get install -y lsof
    lsof
    apt-get install -y procps
    ps aux
    ps aux | grep nginx
    ```
    When you are ready you can write exit and exit from shell.
    Clean up
    ```
    kubectl delete -f 08_shell-demo.yaml
    ```
14. Clean your environment
    ```
    ./delete.sh
    ```