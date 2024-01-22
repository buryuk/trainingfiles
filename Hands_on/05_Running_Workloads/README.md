1. Create a StatefulSet and its headless service
    ```
    kubectl create -f statefulset.yaml
    kubectl create -f sts-svc.yaml
    ```
2. Watch the ordered pod creation of the StatefulSet
    ```
    kubectl get pods
    or
    ```
    kubectl get pods -w
    ```
    First web-0 then web-1 are created

3. Verify that both were created successfully
    ```
    kubectl get statefulset web
    ```
4. Check IP address of pod's DNS records.
    ```
    kubectl run dns-test --image=busybox:1.28 --restart=Never -it --rm  -- sh -c 'nslookup web-0.nginx'
    kubectl run dns-test --image=busybox:1.28 --restart=Never -it --rm  -- sh -c 'nslookup web-1.nginx'
    ```
    Output should be similiar like below:
    ```
    Name:      web-0.nginx
    Address 1: 10.244.120.86 web-0.nginx.default.svc.cluster.local
    Name:      web-1.nginx
    Address 1: 10.244.120.87 web-1.nginx.default.svc.cluster.local
    ```
    Note: The CNAME of the headless service points to SRV records (one for each Pod that is Running and Ready). The SRV records point to A record entries that contain the Pods' IP addresses.

5. Delete the pods
    ```
    kubectl delete pod -l app=nginx
    ```
6. Check IP address of pod's DNS records.
    ```
    kubectl run dns-test --image=busybox:1.28 --restart=Never -it --rm  -- sh -c 'nslookup web-0.nginx'
    kubectl run dns-test --image=busybox:1.28 --restart=Never -it --rm  -- sh -c 'nslookup web-1.nginx'
    ```
    The Pods' ordinals, hostnames, SRV records, and A record names have not changed, but the IP addresses associated with the Pods may have changed. In the cluster used for this tutorial, they have. This is why it is important not to configure other applications to connect to Pods in a StatefulSet by IP address.
    If you need to find and connect to the active members of a StatefulSet, you should query the CNAME of the headless Service (nginx.default.svc.cluster.local). The SRV records associated with the CNAME will contain only the Pods in the StatefulSet that are Running and Ready.
    If your application already implements connection logic that tests for liveness and readiness, you can use the SRV records of the Pods ( web-0.nginx.default.svc.cluster.local, web-1.nginx.default.svc.cluster.local), as they are stable, and your application will be able to discover the Pods' addresses when they transition to Running and Ready

7. Check PersistentVolumeClaims
    ```
    kubectl get pvc
    ```
    See two pvc are created for each pod

8. Check PersistentVolumes
    ```
    kubectl get pv
    ```
    See two pv are created for each pod

9. Delete the pods
    ```
    kubectl delete pod -l app=nginx
    ```
10. See pods are using same PVs and PVCs
    ```
    kubectl get pvc
    kubectl get pv
    ```
11. Scale up the StatefulSet to 5 replicas
    ```
    kubectl scale sts web --replicas=5
    ```
12. Check the pods, PVCs and PVs
    ```
    kubectl get po
    kubectl get pvc
    kubectl get pv
    ```

13. Scale down the StatefulSet to 3 replicas
    ```
    kubectl scale sts web --replicas=3
    ```
14. Check the pods, PVCs and PVs
    ```
    kubectl get po
    kubectl get pvc
    kubectl get pv
    ```
    See the PVCs and PVs are still 5

15. Create a DaemonSet
    ```
    kubectl create -f daemonset.yaml
    ```
    Check an instance was created for each node in your cluster in NODE section
    ```
    kubectl get pods -o wide
    ```
16. Create a Job
    ```
    kubectl create -f job.yaml
    ```
17. Check on the status of the Job with kubectl
    ```
    kubectl describe job pi
    ```
18. To list all the Pods that belong to a Job in a machine readable form, you can use a command like this
    ```
    pods=$(kubectl get pods --selector=job-name=pi --output=jsonpath='{.items[*].metadata.name}')
    echo $pods
    ```
    Then check their logs
    ```
    kubectl logs $pods
    ```
19. Create a CronJob
    ```
    kubectl create -f cronjob.yaml
    ```
20. Get its status using this command
    ```
    kubectl get cronjob hello
    ```
21. Get logs from all the CronJob pods
    ```
    kubectl logs -l app=cronjob
    ```
    Cronjob is created to execute every minute. You need to see a new message every minute.
    Output should be like below:
    ```
    Fri Jan 19 10:04:00 UTC 2024
    Hello from the Kubernetes cluster
    Fri Jan 19 10:03:00 UTC 2024
    Hello from the Kubernetes cluster
    ```
22. Create two deployments with services
    ```
    kubectl create -f ../04_Exposing_Services/First_Deployment
    kubectl create -f ../04_Exposing_Services/Second_Deployment
    ```
    We will use this deployments for below hands-on examples.
23. Create initContainer pod
    ```
    kubectl create -f initcontainer.yaml
    ```
24. Check the status
    ```
    kubectl get -f initcontainer.yaml
    ```
    If you are fast enough, you should see below output:
    ```
    NAME        READY   STATUS     RESTARTS   AGE
    myapp-pod   0/1     Init:0/2   0          1s
    ```
    After init containers finished with successfull, you will see below output:
    ```
    NAME        READY   STATUS    RESTARTS   AGE
    myapp-pod   1/1     Running   0          46s
    ```
    Init container cannot be seen after their job is done.

    In case of error, check the error with below command:
    ```
    kubectl describe -f initcontainer.yaml
    ```

15. Because we know the init container names, we can check the initContainer logs
    ```
    kubectl logs myapp-pod -c init-front-end-svc-1
    kubectl logs myapp-pod -c init-front-end-svc-2
    ```
    Output should be similiar like below:
    ```
    Name:      web.default.svc.cluster.local
    Address 1: 10.124.8.58 web.default.svc.cluster.local
    ```
    and
    ```
    Name:      web2.default.svc.cluster.local
    Address 1: 10.124.2.185 web2.default.svc.cluster.local
    ```
16. Create a pod with Sidecar and its service for checks
    ```
    kubectl create -f sidecar.yaml
    ```
17. Check the pod and its containers on READY section
    ```
    kubectl get po -l app=sidecar-container-demo
    ```
18. Side car logs date and time together with a custom message to Nginx static webpage
    ```
    kubectl run test-curl --image=curlimages/curl --restart=Never --rm  -it -- sh -c 'curl --connect-timeout 5 sidecar-container-demo-svc'
    ```
    Output should be similiar like below:
    ```
    Fri Jan 19 10:17:42 UTC 2024 Hi I am from Sidecar container
    Fri Jan 19 10:17:47 UTC 2024 Hi I am from Sidecar container
    Fri Jan 19 10:17:52 UTC 2024 Hi I am from Sidecar container
    Fri Jan 19 10:17:57 UTC 2024 Hi I am from Sidecar container
    Fri Jan 19 10:18:02 UTC 2024 Hi I am from Sidecar container
    ```
19. Helm
    We can list our repositories with below command:
    ```
    helm repo list
    ```
    It should be empty.
    Let's add a repo
    ```
    helm repo add bitnami https://charts.bitnami.com/bitnami
    ```
    We can search all the charts in all added repos with below command:
    ```
    helm search repo mysql
    ```
    Let's add a repo for our example
    ```
    helm repo add examples https://helm.github.io/examples
    ```
    Let's find it:
    ```
    helm search repo hello
    ```
    Output should be like below:
    ```
    NAME                    CHART VERSION   APP VERSION     DESCRIPTION
    examples/hello-world    0.1.0           1.16.0          A Helm chart for Kubernetes
    ```
    We can install the chart to our Kubernetes or change some values.
    As a start, let's install it with default values
    ```
    helm install myhelloworld examples/hello-world
    ```
    Follow steps in your console. You should see Nginx default welcome page.
    Use Ctrl+C to cancel port forwarding.

    Let's check installed Helm charts:
    ```
    helm list
    ```
    Output should be like below:
    ```
    NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
    myhelloworld  default         1               2024-01-19 17:03:11.195677374 +0100 CET deployed        hello-world-0.1.0       1.16.0
    ```
    Check created deployment
    ```
    kubectl get deploy
    ```
    You should see similiar output like below:
    ```
    NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
    myhelloworld-hello-world   1/1     1            1           9m19s
    ```
    Let's change pod number from 1 to to 2
    To do that we need do download the chart
    ```
    helm pull examples/hello-world --untar
    ```
    Then execute below command
    ```
    helm upgrade myhelloworld --reuse-values --set replicaCount=2 ./hello-world
    ```
    Check Helm charts:
    ```
    helm list
    ```
    See now we have REVISION 2.

    We can see other values can be changed in hello-world/values.yaml.
    Copy values.yaml file to your working directory and change its name to myvalues.yaml file.
    Change replicaCount to 3.
    Then execute below command:
    ```
    helm upgrade myhelloworld -f myvalues.yaml ./hello-world
    ```
    A new revision is installed.

    Check helm chart version:
    ```
    helm list
    ```
    See now revision 3.

    See revisions of a release:
    ```
    helm history myhelloworld
    ```
    We have 3 revisions.

    We can rollback one previous revision with below command:
    ```
    helm rollback myhelloworld
    ```
    Let's check our revisions:
    ```
    helm list
    ```
    Actually, helm went back to one back revision but it created a new revision.
    You can see Description of revision 4 as "Rollback to 2".

    What if we want to go back revision 2 from our point which is revision 4.
    We can specific revision number like below:
    ```
    helm rollback myhelloworld 2
    ```
    Let's check our revision history and see we have 5 revisions now.
    ```
    helm history myhelloworld
    ```
    We can uninstall helm revision like below command:
    ```
    helm uninstall myhelloworld
    ```
    Check if we have any helm revision:
    ```
    helm list
    ```
    It should be nothing!


20. Clean your environment
    ```
    ./delete.sh
    ```