# Problem Statement: Deploying MongoDB with StatefulSet, MongoDB Exporter, and PrometheusRule in Kubernetes

## Design

![Design](./Design.png?raw=true "Design")

## Challenge Overview:

Your task is to design and implement a DevOps pipeline that deploys MongoDB with StatefulSet in a Kubernetes environment, integrates a MongoDB exporter for Prometheus monitoring, and sets up PrometheusRule for alerting and monitoring. The goal is to ensure efficient management of MongoDB instances, data consistency, high availability, and robust monitoring for applications that rely on MongoDB.

##Problem Description:

MongoDB is a NoSQL database that is crucial for many modern applications. Deploying and scaling MongoDB in a Kubernetes cluster using StatefulSets while ensuring efficient monitoring with Prometheus is essential. Additionally, you need to implement PrometheusRule to set up alerting based on critical MongoDB metrics.

## Your Tasks:

### MongoDB Deployment:

Implement an automated MongoDB deployment process using Kubernetes StatefulSets. Ensure that MongoDB pods have persistent storage and that data is maintained across pod restarts or rescheduling.

### Configuration Management:

Design and implement a configuration management system that allows for easy and consistent MongoDB configuration changes, including authentication, authorization, and other database settings.

### MongoDB Exporter:

Integrate MongoDB Exporter to collect essential MongoDB metrics and expose them to Prometheus. Ensure that MongoDB Exporter is properly configured to scrape data from MongoDB instances.

### Prometheus and Alerting:

Set up Prometheus to scrape metrics from MongoDB Exporter. Define PrometheusRule to create alerting rules based on critical MongoDB metrics, such as latency, connections, and replication status.

### Scaling:

Create a solution that allows for easy horizontal scaling of MongoDB instances. Implement auto-scaling based on workload and resource utilization, and ensure that data remains consistent across scaled instances.

### Backup and Restore:

Develop a mechanism for regular MongoDB data backups and the ability to restore data in the event of failures or data corruption.

### Documentation:

Provide clear and concise documentation for the entire MongoDB deployment and management process in a Kubernetes environment, including details on the MongoDB Exporter and PrometheusRule setup.

### Evaluation Criteria:

1. Effectiveness of MongoDB deployment using StatefulSets.
2. Proper integration and configuration of MongoDB Exporter.
3. Configure monitoring for the Kubernetes environment using the Kube Prometheus stack to ensure timely identification of critical issues. Define alert conditions for triggering an alert in Alertmanager based on the following criteria:
    1. Pod State Monitoring:
        1. Trigger an alert in Alertmanager if any Pods are in a 'NotReady' state.
    2. Connection Threshold Monitoring:
        1. Set up monitoring to trigger an alert in Alertmanager if the number of connections exceeds 10.
4. Data consistency and persistence across MongoDB instances.
5. Efficiency and scalability of the solution.
6. Backup and restore capabilities.
7. Documentation quality and clarity.
8. Creativity and innovation in addressing the challenges.
9. API and DB should be running on different nodes.

### Additional Information:

You will be provided with access to the Kubernetes cluster and necessary tools and resources (container images) to complete the task. You are encouraged to collaborate in teams or work individually, and you will have a specific time frame to complete the challenge.

### Images

- Database: yukselburak/mongodb:latest
- App: yukselburak/app:latest
- Mongo Seed: yukselburak/mongo-seed:latest

### Tips

1. Secret for database needs to include username: admin and password: burak3409
2. Database needs below environment variables:
    - MONGO_INITDB_ROOT_USERNAME
    - MONGO_INITDB_ROOT_PASSWORD
    - MONGO_INITDB_DATABASE (This should be admin)
3. App and Mongo Seed Job need below environment variables:
- MONGO_USERNAME
- MONGO_PASSWORD
- MONGO_INITDB_DATABASE
4. Horizontal Pod Autoscaler needs to point to the deployment.
5. Prometheus Service Monitor needs to point to the Service labels.
6. Prometheus Rule is created for Prometheus itself.



### Extra
1. Configure Mongo Exporter to export logs to Prometheus
2. Use mongoexport/mongoimport to export and import in case of any data loss
3. Make tests to API with listing all records, delete a record, add a record and update a record. Tip: There is an interface to do that.