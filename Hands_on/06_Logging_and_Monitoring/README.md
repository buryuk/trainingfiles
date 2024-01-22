1. Verify Prometheus installation

    Port forward to prometheus 9090
    ```
    kubectl port-forward svc/prometheus-operated 9090:9090 -n monitoring
    ```
2. Open prometheus in a browser
    Go to: http://127.0.0.1:9090

    Open another zsh or bash.
    Create a test deployment:
    ```
    kubectl create -f front-end-deploy.yaml
    ```
    Create a Prometheus Service monitor
    ```
    kubectl create -f svc_monitor.yml
    ```
    It takes around 1 minute to get logs to Prometheus.
6. Verify results in Prometheus

    Open in browser: http://127.0.0.1:9090/graph?g0.expr=nginx_http_response_count_total%7Bstatus%3D%22200%22%7D
    - go to the "graph" tab

    You can select time to 5m to see better graph.

7. In prometheus we can use the sum() aggregator to unify our metrics across dimensions

    - add the following expression: sum(nginx_http_response_count_total{status="200"})

    It is total response count.

8. In prometheus we can use take derivatives of metrics with the the rate() operator.
    We can define a time window with the help of the '[]' operator:
    - add the following expression: rate(nginx_http_response_count_total{status="200"}[2m])

    Change it to below:
    - add the following expresison to see collectively: sum(rate(nginx_http_response_count_total{status="200"}[2m]))

9. Grafana
    Port forward to prometheus 9090
    ```
    kubectl port-forward svc/kube-prom-stack-grafana 8090:80 -n monitoring
    ```
    Open Grafana in a browser
    Go to: http://127.0.0.1:8090
    Enter below:
    Username: admin
    Password: prom-operator

    Open another zsh or bash.


    Go to Toggle Menu top left corner
    - New buttton on the right
    - New dashboard
    - Add visulation
    - Select Prometheus as data source
    - Metric on bottom left select nginx_http_response_count_total
    - Select label: status
    - Select value: 200
    - Click Run queries

    You can click +Operations button and select Sum for get total count for all the pods' requests.

10. Clean your environment
    ```
    ./delete.sh
    ```