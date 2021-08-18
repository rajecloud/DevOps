# Logstash-operator (Logstash operator Helm Chart)

## Overview
 
A prerequesite before using this is that a Kubernetes Cluster Administrator have previously pushed the elastic images to Artifactory, added the Elastic search Custom Resource Definitions (CRDs) and run the `push` SaaS CI Pipeline to create the `logstash-operator` namespace to facilitate using the logstash operator (see the [master branch](https://github.gwd.broadcom.net/dockcpdev/logstash-operator/blob/master/README.md) for details).

Please read the [Elastic documentation](https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html) to gain an understanding of the features of the Operator.

## Prerequsites

In the [deploy-info.yml](./deploy-info.yml), the following base project, operator and team needs to be defined:

```
base_project_name: "logstash-operator"
base_image_pull_service_account: "all"
operator: "true"
operator_service_account: "logstash-operator"
team:
  name: "logstash-operator"
  token: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
```

The token value for the environmentis created and managed by the Saas Ops team. Raise a SaaS ticket if you need to get the token for a specific environment.

## Install and manage the Operator via the SaaS Ops CD pipeline

In your own gitops repo, create a new branch and copy the [/operator](./operator) folder and its yaml contents, [Jenkinsfile](./Jenkinsfile), [deploy-info.yml](./deploy-info.yml), [helm-command.yml](./helm-command.yml) and [values.yaml](./values.yaml) to it from this branch. Ensure your copied `Jenksinfile` is triggering the expected SaaS Ops CD Pipeline code (dev for dockcpdev repos and master for dockcp repos) and edit your copied `deploy-info.yml` to ensure it is deploying to the expected namespace (defined by the `project_name` setting in [deploy-info.yml](./deploy-info.yml) and GKE cluster (defined by the `kubernetes.env.name` setting in [deploy-info.yml](./deploy-info.yml)).

Performing a commit to the branch deploys the `elastic-operator-1.0.0.tgz` helm chart which runs a Kubernetes Job to take the relevant Operator action. When the chart is deployed via the SaasOps CD pipeline, the operator yaml contained in the [operator](./operator) folder is added to a [ConfigMap](./chart/elastic-operator/templates/elastic-operator-configmap.yaml) .The ConfigMap gets mounted to an `/operator` folder in a [Job](./chart/elastic-operator/templates/elastic-operator-job.yaml) and provided with the following environment variables

* **RUN_TIME**: This is auto-generated to ensure each git commit will trigger the job to run
* **KUBERNETES_INTERNAL_API_SERVER**: If a private GKE cluster, define the internal Kubernetes API IP
* **KUBERNETES_NAMESPACE**: Taken from the `project_name` field in `deploy-info.yml`
* **BASE_KUBERNETES_NAMESPACE**: Taken from the `base_project_name` field in `deploy-info.yml`. This needs to be `elastic-operator`
* **BASE_KUBERNETES_NAMESPACE_SERVICE_ACCOUNT**: Taken from the `operator_service_account` field in `deploy-info.yml`. This needs to be `logstash-operator`
* **BASE_KUBERNETES_NAMESPACE_SERVICE_ACCOUNT_TOKEN**: This is retrieved and the value set automatically by the SaaS Ops CD pipeline. After each pipeline run it is revoked.
* **OPERATOR_COMMAND**: Taken from the `command` field in `values.yaml`. See below for the list of supported commands for the Elastic operator
* **OPERATOR_IMAGES**: Taken from the `image.repository` field in `values.yaml`. This needs to be `gcr.io/<gcp-project-id>/<env-name>/logstash-operator/logstash-operator
* **OPERATOR_POD**: Taken from the `podName` field in `values.yaml`. This needs to be `elastic-operator-0`
* **OPERATOR_POD_LOGSTASH** : Taken from the `podNameLogstash` field in `values.yaml`. the needs to be `logstash-operator-0`

## Commands available for the Elastic Operator via the SaaS Ops CD Pipeline

### General Information on the running of commands
When the `logstash-operator` helm chart runs via the Saas Ops CD pipeline, the [Job](./chart/elastic-operator/templates/elastic-operator-job.yaml) with mounted [ConfigMap](./chart/elastic-operator/templates/elastic-operator-configmap.yaml) and associated environment variable values referenced above are run.

The job runs in the GKE Kubernetes cluster using the provided `BASE_KUBERNETES_NAMESPACE_SERVICE_ACCOUNT` serviceaccount token (retrieved automatically from the `logstash-operator` namespace). When the Job completes (whether successful or not), the serviceaccount token is revoked to ensure that a new token is generated; this ensures that no-one can login using that serviceaccount token after the job has run.

## Presteps before you run the Saas Ops CD Pipeline for the first time

* In [values.yaml](./values.yaml), set the `command` field to `deploy-elk-cluster`. Edit the `image.repository` value to use your GCP project ID and env name (as defined in your [deploy-info.yml](./deploy-info.yml).
* Likewise, edit the [/operator/operator.yaml](./operator/operator.yaml) , [/operator/elasticsearch_cr.yaml](./operator/cr.yaml) and [/operator/deployment_logstash-cr.yaml](./operator/deployment_logstash-cr.yaml),[/operator/operator-logstash.yaml](./operator/operator-logstash.yaml) to ensure any image references use your GCP project ID and the environment name as defined in your [deploy-info.yml](./deploy-info.yml). Essentially, ensure that aywhere you see reference to `gcr.io` that you update to have the path to the images in your projects Container regsistry - i.e. `gcr.io/<gcp-project-id>/<env-name>/logstash-operator`.

### deploy-elk-cluster

You need to define the relevant settings for your cluster to the [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml) ,
[/operator/deployment_logstash-cr.yaml](./operator/deployment_logstash-cr.yaml) , [/operator/kibana_cr.yaml](./operator/kibana_cr.yaml)
Trigger the SaaS Ops CD pipeline by making a commit to the github branch. This will then perform a elastic cluster deployment to the specified namespace by running the following commands:

1. Apply cluster-role.yaml<br/>
   kubetl apply -f [/operator/cluster-role.yaml](./operator/backup-s3.yaml)<br/>
2. Apply serviceaccount<br/>
   kubectl apply -f [/operator/service-account.yaml](./operator/role-binding.yaml)<br/>
3. Apply cluster-role-binding.yaml<br/>
   kubectl apply -f [/operator/cluster-role-binding.yaml](./operator/cluster-role-binding.yaml)<br/>
4. Apply elastic-webhook-server.yaml<br/>
   kubectl apply -f [/operator/elastic-webhook-server.yaml](./operator/elastic-webhook-server.yaml)<br/>
5. Apply operator.yaml<br/>
   kubectl apply -f [/operator/operator.yaml](./operator/operator.yaml)<br/>
6. Perfom the Elastic cluster deployment<br/>
   kubectl apply -f [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)
7. Perfom the Kibana cluster deployment<br/>
   kubectl apply -f [/operator/kibana_cr.yaml](./operator/kibana_cr.yaml)
8. Apply role-logstash.yaml<br/>
   kubectl apply -f [/operator/role-logstash.yaml](./operator/role-logstash.yaml)<br/>
9. Apply role-binding-logstash.yaml<br/>
   kubectl apply -f [/operator/role-binding-logstash.yaml](./operator/role-binding-logstash.yaml)<br/>
10. Apply service-account.yaml<br/>
    kubectl apply -f [/operator/service-account.yaml](./operator/role-logstash.yaml)<br/>
11. Apply operator-logstash.yaml<br/>
    kubectl apply -f [/operator/operator-logstash.yaml](./operator/operator-logstash.yaml)<br/>
12. Apply deployment_logstash_cr.yaml<br/>
    kubectl apply -f [/operator/deployment_logstash-cr.yaml](./operator.deployment_logstash-cr.yaml)<br/>
   
### delete-elk-cluster

This option will be used for the clean up process of the cluster and wil delete all the resources present inside the cluster :

1. delete cluster-role.yaml<br/>
   kubetl delete -f [/operator/cluster-role.yaml](./operator/backup-s3.yaml)<br/>
2. delete serviceaccount<br/>
   kubectl delete -f [/operator/service-account.yaml](./operator/role-binding.yaml)<br/>
3. delete cluster-role-binding.yaml<br/>
   kubectl delete -f [/operator/cluster-role-binding.yaml](./operator/cluster-role-binding.yaml)<br/>
4. delete elastic-webhook-server.yaml<br/>
   kubectl delete -f [/operator/elastic-webhook-server.yaml](./operator/elastic-webhook-server.yaml)<br/>
5. delete operator.yaml<br/>
   kubectl delete -f [/operator/operator.yaml](./operator/operator.yaml)<br/>
6. Perfom the Elastic cluster deployment<br/>
   kubectl delete -f [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)
7. delete role-logstash.yaml<br/>
   kubectl delete -f [/operator/role-logstash.yaml](./operator/role-logstash.yaml)<br/>
8. delete role-binding-logstash.yaml<br/>
   kubectl delete -f [/operator/role-binding-logstash.yaml](./operator/role-binding-logstash.yaml)<br/>
8. delete service-account.yaml<br/>
   kubectl delete -f [/operator/service-account.yaml](./operator/role-logstash.yaml)<br/>
9. delete operator-logstash.yaml<br/>
   kubectl delete -f [/operator/operator-logstash.yaml](./operator/operator-logstash.yaml)<br/>
10. delete deployment_logstash_cr.yaml<br/>
    kubectl delete -f [/operator/deployment_logstash-cr.yaml](./operator.deployment_logstash-cr.yaml)<br/>
   
 ### provision kibana
 
 This option can be used once the cluster is up and can be used to change the configuration of kibana resource while the cluster is in running state.
 
1. Perfom the Kibana cluster provisioning<br/>
   kubectl apply -f [/operator/kibana_cr.yaml](./operator/kibana_cr.yaml)
   
#### scaleup and scale-down kibana cluster

* Change the count value in kibana_cr.yaml and use provision-kibana command , it will perform the action based on the value i.e. scale up or scale down.

```
apiVersion: kibana.k8s.elastic.co/v1
  kind: Kibana
  metadata:
    name: kibana-config
  spec:
    version: 7.4.0
    count: 1
    elasticsearchRef:
      name: "elasticsearch-config"
```
   
### deprovision kibana

This option is used to deprovision the kibana cluster as required.

2. Perfom the Kibana cluster de-provisioning<br/>
   kubectl delete -f [/operator/kibana_cr.yaml](./operator/kibana_cr.yaml)
   
### provision-elasticssearch

This option can be used once the cluster is up and can be used to change the configuration of elasticsearch resource while the cluster is in running state.
 
1. Perfom the elasticsearch cluster provisioning<br/>
   kubectl apply -f [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)
 
#### scaleup and scale-down elasticsearch cluster

* Change the count value in elasticsearch_cr.yaml and use provision-elaticsearch command , it will perform the action based on the value i.e. scale up or scale down.

```
apiVersion: elasticsearch.k8s.elastic.co/v1
  kind: Elasticsearch
  metadata:
    name: elasticsearch-config
  spec:
    version: 7.4.0
    secureSettings:
    - secretName: gcs-credentials
    nodeSets:
    - name: master
      count: 1
  ```
 #### custom plugin installation
 
 * You can achieve this feature in two ways 1) before deploy-elk-cluster 2) after deploy-elk-cluster commands being executed.
 * before deploy-elk-cluster - change the plugin name in init-container under elasticsearch_Cr.yaml and it will install the plugin for      you after the cluster comes up
 
 ```
  initContainers:
          - name: install-plugins
            command:
            - sh
            - -c
            - |
              bin/elasticsearch-plugin install --batch repository-gcs
 ```
 * after-deploy-elk command being executed - you can change the plugin name after the ELK cluster is up and use provision-elasticsearch    command from values.yaml to install the plugin by updating elasticsearch_cr.yaml
   note: it will restart the elasticsearch nodes.
   
 ```
  initContainers:
          - name: install-plugins
            command:
            - sh
            - -c
            - |
              bin/elasticsearch-plugin install --batch repository-gcs
```
* if you dont wish to install any plugins and tend to opt for vanilla elasticsearch image provided by vendor or use hardened image where plugins have already been installed , while deploy-elk-cluster comment these lines in elasticsearch_cr.yaml

```
 #initContainers:
 #         - name: install-plugins
 #           command:
 #           - sh
 #           - -c
 #           - |
 #             bin/elasticsearch-plugin install --batch repository-gcs
```
 
 
### deprovision-elasticsearch

This option is used to deprovision the elasticsearch cluster as required.

2. Perfom the Kibana cluster de-provisioning<br/>
   kubectl delete -f [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)
   
### provision-logstash

This option can be used once the cluster is up and can be used to change the configuration of logstash resource while the cluster is in running state.
 
1. Perfom the logstash cluster provisioning<br/>
   kubectl apply -f [/operator/deployment_logstash-cr.yaml](./operator/deployment_logstash-cr.yaml)

#### scaleup and scale-down logstash cluster

* Change the count value in deployment_logstash-cr.yaml and use provision-logstash command , it will perform the action based on the value i.e. scale up or scale down.

```
      timeoutSeconds: 30
    replicaCount: 1
    resources: {}
    securityContext:
      fsGroup: 1000
      runAsUser: 0
```
  
### deprovision-logstash

This option is used to delete the logstash resource as required
 
1. Perfom the logstash cluster provisioning<br/>
   kubectl delete -f [/operator/deployment_logstash-cr.yaml](./operator/deployment_logstash-cr.yaml)
   
 ### Config Changes
 
 The config can be added and configured in [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml), below are the config    parameters where we can pass values according to the infra needs and elasticsearch cluster will be updated , these parameters should be configured before deploy-cluster command :

```
cluster.name
discovery.zen.minimum_master_nodes [7.0]Deprecated in 7.0.
cluster.initial_master_nodes [7.0]Added in 7.0.
network.host
network.publish_host
path.data
path.logs
xpack.security.authc.reserved_realm.enabled
xpack.security.enabled
xpack.security.http.ssl.certificate
xpack.security.http.ssl.enabled
xpack.security.http.ssl.key
xpack.security.transport.ssl.certificate
xpack.security.transport.ssl.enabled
xpack.security.transport.ssl.key
xpack.security.transport.ssl.verification_mode
```
### Custom HTTP certificate

You can provide your own CA and certificates instead of the self-signed certificate to connect to Elasticsearch via HTTPS using a Kubernetes secret. The certificate must be stored under tls.crt and the private key must be stored under tls.key. If your certificate was not issued by a well-known CA, you must include the trust chain under ca.crt as well.

You need to reference the name of a secret that contains a TLS private key and a certificate (and optionally, a trust chain), in the spec.http.tls.certificate section.

```
spec:
  http:
    tls:
      certificate:
        secretName: <cert-name>
```
#### xpack config for logstash

```
xpack.monitoring.elasticsearch.hosts:
- https://elasticsearch-config-es-http:9200
xpack.monitoring.elasticsearch.username: "elastic"
xpack.monitoring.elasticsearch.password: "${SECRET_ES_PASSWORD}"
xpack.monitoring.elasticsearch.ssl.certificate_authority: "/etc/certificate/ca.crt"
```
#### output config for logstash

```
  elasticsearch {
            hosts => ["${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}"]
            manage_template => false
            user => "elastic"
            password => "${SECRET_ES_PASSWORD}"
            ssl => true
            ssl_certificate_verification => false
            cacert => <cert-path>
            index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
 ```
 
 #### cert mounts for logstash
 
 ```
  volumes:
    - name: certs
      secret:
        secretName: <custom-cert-secret-name>
 ```
 
### User Management

When the Elasticsearch resource is created, a default user named elastic is created automatically, and is assigned the superuser role.

#### Creating Custom Users

* using native realm 
The native realm is available by default when no other realms are configured. If other realm settings have been configured in elasticsearch.yml, you must add the native realm to the realm chain.

You can configure a native realm in the xpack.security.authc.realms.native namespace in elasticsearch.yml. Explicitly configuring a native realm enables you to set the order in which it appears in the realm chain, temporarily disable the realm, and control its cache options.

Add a realm configuration to elasticsearch.yml under the xpack.security.authc.realms.native namespace. It is recommended that you explicitly set the order attribute for the realm.

See Native realm settings for all of the options you can set for the native realm. For example, the following snippet shows a native realm configuration that sets the order to zero so the realm is checked first:
```
xpack:
  security:
    authc:
      realms:
        native:
          native1:
            order: 0
```

* using File-realm

Custom users can also be created by providing the desired file realm content in Kubernetes secrets, referenced in the Elasticsearch resource.

```
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: elasticsearch
spec:
  version: 7.4.0
  image: <image-name>
  auth:
    fileRealm:
    - secretName: my-filerealm-secret-1
    - secretName: my-filerealm-secret-2
```
Referenced secrets may be composed of 2 entries. You can provide either entry or both entry in each secret:

users: content of the users file. It specifies user names and password hashes
users_roles: content of the users_roles file. It associates each role to a list of users

```
kind: Secret
apiVersion: v1
metadata:
  name: my-filerealm-secret
stringData:
  users: |-
    rdeniro:$2a$10$BBJ/ILiyJ1eBTYoRKxkqbuDEdYECplvxnqQ47uiowE7yGqvCEgj9W
    alpacino:$2a$10$cNwHnElYiMYZ/T3K4PvzGeJ1KbpXZp2PfoQD.gfaVdImnHOwIuBKS
    jacknich:{PBKDF2}50000$z1CLJt0MEFjkIK5iEfgvfnA6xq7lF25uasspsTKSo5Q=$XxCVLbaKDimOdyWgLCLJiyoiWpA/XDMe/xtVgn1r5Sg=
  users_roles: |-
    admin:rdeniro
    power_user:alpacino,jacknich
    user:jacknich
 ```
 roles can also be configured using file realm
 ```
 kind: Secret
apiVersion: v1
metadata:
  name: my-roles-secret
stringData:
  roles.yml: |-
    click_admins:
      run_as: [ 'clicks_watcher_1' ]
      cluster: [ 'monitor' ]
      indices:
      - names: [ 'events-*' ]
        privileges: [ 'read' ]
        field_security:
          grant: ['category', '@timestamp', 'message' ]
        query: '{"match": {"category": "click"}}'
   ```
