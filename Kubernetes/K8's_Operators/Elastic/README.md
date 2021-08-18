# Elastic Operator

## Release

### v1.1.5
* Features
  * Added a base image for apmia.
  * Automation of project-id and envirinent variables.
  
* Bug Fixes
  * NA
  
 * Release Notes
   * A new section called [automation of project-id and environment variable](#automation-of-project-id-and-environment-variable) has been added.
   * **Operator Job Image: `elasticsearch-operator:1.1.5` Helm Chart: `elasticsearch-operator-1.1.6.tgz`**
#### v1.1.2

* Features
  * AIOPS Integrated with elastic search, with a toggle option as `deployAiopsAgent` in `values.yaml`
  * Added Table of contents in Readme for ease of traversing through different topics
  
* Bug Fixes
  * NA

* Release Notes
  * Go through the [AIOPS DOCUMENTATION](#aiops) to configure AIOPS in your GKE environment
  * **Operator Job Image: `elasticsearch-operator:1.1.2` Helm Chart: `elasticsearch-operator-1.1.0.tgz`**

## Demo

Please view the below recording for a demonstration of the steps documented in this README.

[Watch the recording - Part 1](https://drive.google.com/open?id=1qyFQxStI6TCRJQzFMnslnP1nBpxxix8Z)
[Watch the recording - Part 2](https://drive.google.com/open?id=1FkAY8ACipuHOYJ4U9emYE6z6JZtKfioS)

## Overview
 
This README provides instructions to deploy and maintain a Elasticsearch cluster to a GKE Kubernetes Cluster using the elastic operator. The elastic operator is the official operator provided by [elastic](https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html).

A prerequesite before using this is that a Kubernetes Cluster Administrator has previously pushed the elastic operator images to Artifactory, added the elasticsearch Custom Resource Definitions (CRDs) and run the push SaaS Ops CD Pipeline to create the elastic-operator namespace to facilitate using the elastic operator. These actions will have been performed by the SaaS Ops team for any of the managed GKE environments.

Please read the [Elastic documentation](https://www.elastic.co/guide/en/cloud-on-k8s/current/index.html) to gain an understanding of the features of the Operator.

Table of contents
=================

* [Prerequsites](#pre)
* [Available Commands for Elastic Operator](#available-commands)
  * [deploy-cluster](#deploy)
  * [delete-cluster](#delete)
  * [provision-kibana](#provision)
  * [deprovision-kibana](#deprovision)
  * [create-custom-user-role](#create-user)
  * [enable-backup-cron-job](#cron)
  * [deploy-curator](#deploycurator)
  * [delete-curator](#deletecurator)
* [How to connect to Elastic Search Cluster](#how-to-connect)
* [Scaling the elasticsearch cluster](#scaling)
* [Plugin Management](#plugin)
* [Kibana Ingress](#kibana-ingress)
* [Certificate Management](#cert-management)
* [Backup Solution](#backup)
  * [Snapshot and Restore](#snapshot)
  * [Backup Cron Job](#cron)
* [Upgrade Cluster](#upgrade)
* [Pod Disruption Budget](#pdb)
* [Pod Affinity](#podafiinity)
* [Internal Load Balancer for ES](#ilb)
* [AIOPS agent Integration](#aiops)
  * [AIOPS YAML config changes](#aiops-config)
* [node attributes](#nodeattr)
* [automation of project-id and environment variable](#automation-of-project-id-and-environment-variable)
## <a name="pre"></a>Prerequsites

In the [deploy-info.yml](./deploy-info.yml), edit the `project_name` and `email` values and, if needed, edit the `kubernetes.env.name` value.

The following base project, operator and team needs to be defined as listed and should not be edited:

```yaml
base_project_name: "elastic-operator"
base_image_pull_service_account: "all"
operator: "true"
operator_service_account: "elastic-operator"
team:
  name: "elastic-operator"
  token: "4508ef94-dd16-ea99-556f-c96c7da52bf4"
```

The **token** value for the environment is created and managed by the SaaS Ops team.

## Install and Manage the Operator via the SaaS Ops CD pipeline

In your own gitops repo, create a new branch and copy the [/operator](./operator) folder and its yaml contents, [Jenkinsfile](./Jenkinsfile), [deploy-info.yml](./deploy-info.yml), [helm-command.yml](./helm-command.yml) and [values.yaml](./values.yaml) to it from this branch. Ensure your copied Jenksinfile is triggering the expected SaaS Ops CD Pipeline code (dev for dockcpdev repos and master for dockcp repos) and edit your copied [deploy-info.yml](./deploy-info.yml) to ensure it is deploying to the expected namespace (defined by the project_name setting in [deploy-info.yml](./deploy-info.yml) and GKE cluster (defined by the kubernetes.env.name setting in [deploy-info.yml](./deploy-info.yml)).

Performing a commit to the branch triggers the SaaS Ops CD Pipeline and will run one of the commands as documented below.

### Presteps before you run the Saas Ops CD Pipeline for the first time

* In [values.yaml](./values.yaml), edit the `image.repository` value to use your GCP project ID and env name (as defined in your [deploy-info.yml](./deploy-info.yml).
* Likewise, edit the [/operator/operator.yaml](./operator/operator.yaml) and [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml) to ensure any image references use your GCP project ID and the environment name as defined in your [deploy-info.yml](./deploy-info.yml). Essentially, ensure that anywhere you see reference to `gcr.io` that you update to have the path to the images in your projects container registry - i.e. `gcr.io/<gcp-project-id>/<env-name>/elastic-operator`.

## <a name="available-commands"></a>Commands available for the Elastic Operator

### <a name="deploy"></a>deploy-cluster

* In [values.yaml](./values.yaml), set the `command` field to `deploy-cluster`. 
* Define the relevant settings for your cluster in the [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml).

Trigger the SaaS Ops CD pipeline by making a commit to the github branch.

### <a name="delete"></a>delete-cluster

* In [values.yaml](./values.yaml), set the `command` field to `delete-cluster`.

Trigger the SaaS Ops CD pipeline by making a commit to the github branch.

### <a name="provision"></a>provision-kibana

Note, the `deploy-cluster` command mut be run before this command will work.

* In [values.yaml](./values.yaml), set the `command` field to `provision-kibana`.

Trigger the SaaS Ops CD pipeline by making a commit to the github branch.

### <a name="deprovision"></a>deprovision-kibana

* In [values.yaml](./values.yaml), set the `command` field to `deprovision-kibana`.

Trigger the SaaS Ops CD pipeline by making a commit to the github branch.

## <a name="Scaling"></a>Scaling an elastic cluster

* In [values.yaml](./values.yaml), set the `command` field to `deploy-cluster`.
This option is used to change the configuration of elasticsearch cluster, you can leverage the following file to achieve scale-up , scale-down, configuration changes, plugin installation i.e. [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)

* In [values.yaml](./values.yaml), set the `command` field to `deploy-cluster`.
* In [/operator/elasticsearch_cr.yaml](./operator/elasticsearcg_cr.yaml) change the `count` value to the required number.

```yaml
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
## <a name="Plugin"></a>Adding a Custom Plugin
 
You can configure adding a custom plugin either before deploying the cluster with the `deploy-cluster` command or after the cluster has been deployed using `deploy-cluster`.
 
* Before `deploy-cluster` - change the plugin name in the `init-container` in [/operator/elasticsearch_cr.yaml](./operator/operator.yaml) and it will install the plugin for you after the cluster comes up
 
 ```yaml
  initContainers:
          - name: install-plugins
            command:
            - sh
            - -c
            - |
              bin/elasticsearch-plugin install --batch repository-gcs
 ```
 
* After `deploy-cluster` - change the plugin name in [/operator/elasticsearch_cr.yaml] and use `deploy-cluster` command to install the plugin. This will cause the elasticsearch nodes to restart with the plugin available in them.
   
* If you dont wish to install any plugins and opt to use the vanilla elasticsearch image provided by the vendor or use a hardened image where plugins have already been installed, before running the `deploy-cluster` command, comment the following lines in [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml) as follows:

```yaml
 #initContainers:
 #         - name: install-plugins
 #           command:
 #           - sh
 #           - -c
 #           - |
 #             bin/elasticsearch-plugin install --batch repository-gcs
```

### <a name="kibana-ingress"></a>Accessing Kibana via Ingress

* A kibana ingress object will be created when you provision it using the `provision-kibana` command. It will be named `kibana-ingress` in the namespace where you provisioned kibana too.
* By default, the ingress object may not be accessible externally due to firewall restrictions. In order to access it, you may need to contact the SaaS Ops team (raise a 1.Support ticket if necessary) to perform the following:
1) In your namespace, click on the `kibana-ingress` object in the GCP console.
2) Go to the ingress service which will be named `kibana-config-kb-http` or any other custom name that you may have chosen at kibana provisioning time
3) Access the events tab and look for a gcloud command that is referenced. A person with the appropriate priveleges (e.g. SaaS Ops team member) can run that command to add the necessary Google firewall rul that will open the ingress to external traffic.
After sometime you will see kibana ingress coming up with no issues

### <a name="how-to-connect"></a>How to connect to the elasticsearch cluster

1. A default superuser and password will be created for the elasticsearch cluster as a secret and, as xpack is enabled by default, a username/password is required to access the elasticsearch API. To get the user and password details:

```shell
kubectl get secret -n <namespace> | grep elastic-user

elasticsearch-config-es-elastic-user                        Opaque                                1      20h

PASSWORD=$(kubectl get secret elasticsearch-config-elastic-user -n <namespace> -o go-template='{{.data.elastic | base64decode}}')

```

2. Obtain the elasticsearch service API:

```shell
kubectl get svc -n <namespace> | grep es-http
elasticsearch-config-es-http          ClusterIP      172.30.117.161   <none>        9200/TCP         20h

```

3. Access to the elasticsearch service API:

```shell
curl -u "elastic:$PASSWORD" -k "https://elasticsearch-config-es-http:9200"

```
4. If successful, you will get a json response from elasticsearch similar to the following, indicating that the elasticsearch cluster is up and fine

```json
{
  "name" : "",
  "cluster_name" : "",
  "cluster_uuid" : "XqWg0xIiRmmEBg4NMhnYPg",
  "version" : {...},
  "tagline" : "You Know, for Search"
}
```
5. Documentation for the elasticsearch service API is available at:

* See the vendor [Document Api](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs.html) section in the documentation.

### <a name="cert-management"></a>Certificate Management

You can provide your own CA and certificates instead of the self-signed certificate to connect to Elasticsearch via HTTPS using a Kubernetes secret. The certificate must be stored under tls.crt and the private key must be stored under tls.key. If your certificate was not issued by a well-known CA, you must include the trust chain under ca.crt as well.

You need to reference the name of a secret that contains a TLS private key and a certificate (and optionally, a trust chain), in the spec.http.tls.certificate section.

```yaml
spec:
  http:
    tls:
      certificate:
        secretName: custom-cert
```

#### Custom self-signed certificate using OpenSSL

This example illustrates how to create your own self-signed certificate for the quickstart Elasticsearch cluster using the OpenSSL command line utility

```shell
openssl req -x509 -sha256 -nodes -newkey rsa:4096 -days 365 -subj "/CN=<cluster-name>" -addext "subjectAltName=DNS:<dns-name>" -keyout tls.key -out tls.crt
$ kubectl create secret generic <custom-cert> --from-file=ca.crt=tls.crt --from-file=tls.crt=tls.crt --from-file=tls.key=tls.key
```
#### Custom HTTP certificate

lets Take a quick example of logstash which is an external application accessing elasticsearch API and how can we configure certificate and enable xpack for secure communication.

1. Configure xpack to mention username,password and cert path
2. Mount the cert as a secret and refrence it in you config path.

Please see the below config for better understanding

#### xpack config for logstash

```yaml
xpack.monitoring.elasticsearch.hosts:
- https://elasticsearch-config-es-http:9200
xpack.monitoring.elasticsearch.username: "elastic"
xpack.monitoring.elasticsearch.password: "${SECRET_ES_PASSWORD}"
xpack.monitoring.elasticsearch.ssl.certificate_authority: "/etc/certificate/ca.crt"
```
#### output config for logstash

```yaml
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
 
```yaml
  volumes:
    - name: certs
      secret:
        secretName: <custom-cert-secret-name>
```
#### Disable TLS

To disable TLS communication in elastic search cluster uncomment following lines from [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)

```yaml
#To disable TLS uncomment following lines:
  http:
    tls:
      selfSignedCertificate:
        disabled: true
```  
### <a name="create-user"></a>create-custom-user-role

This option will be used in two scenarios:
a) creating users with default roles
b) creating users with custom roles

* Creating users with default roles:

You can find the default roles supported by elastic according to versions [HERE](https://www.elastic.co/guide/en/elasticsearch/reference/current/built-in-roles.html)

For example:
`kibana_admin` - Grants access to all features in Kibana. For more information on Kibana authorization, see Kibana authorization.

You will need to create encrypted password for custom users using the following process :

```shell
# create a folder with the 2 files
mkdir filerealm
touch filerealm/users filerealm/users_roles

# create user '<custom-user-name>' with role '<any-default-role>'
docker run \
    -v filerealm:/usr/share/elasticsearch/config \
    docker.elastic.co/elasticsearch/elasticsearch:<elastic-search-version> \
    bin/elasticsearch-users useradd <custom-user-name -p <custom-password> -r <any-default-role>
```

you will have two files users and users_roles available with the hashed passwords and role mapping which you will need to use in [/operator/user-management-file-realm-secret.yaml](./operator/user-management-file-realm-secret.yaml) like this:
 
 ```yaml
 kind: Secret
  apiVersion: v1
  metadata:
    name: user-management-filerealm-secret
  stringData:
    users: |-
      es-monitor:$2a$10$GEV4f3gMt2VxaxJq0HlxPOnMwQ2mQ2QGZMHV1gWWoAZCTwS9VZ5DC
    users_roles: |-
      monitoring_user:es-monitor
      kibana_user:es-monitor
```
once you use the command the user will be created with appropriate default role assigned

* creating users with custom roles

you can define the custom roles here  [/operator/custom-roles-secret.yaml](./operator/custom-roles-secret.yaml) it will contain one or multiple custom role definition:

```yaml
kind: Secret
  apiVersion: v1
  metadata:
    name: custom-role-secret
  stringData:
    roles.yml: |-
      #customrolename
      click_admins:  --> role 1
        run_as: [ 'clicks_watcher_1' ]
        cluster: [ 'monitor' ]
        indices:
        - names: [ 'events-*' ]
          privileges: [ 'read' ]
          field_security:
            grant: ['category', '@timestamp', 'message' ]
          query: '{"match": {"category": "click"}}'
      click_admins_role_new: --> role2
        run_as: [ 'clicks_watcher_1' ]
        cluster: [ 'monitor' ]
        indices:
        - names: [ 'events-*' ]
          privileges: [ 'write' ]
          field_security:
            grant: ['category', '@timestamp', 'message' ]
          query: '{"match": {"category": "click"}}'
  ```
then you can go through the same process to create a hashed password for the custom user who will be using this custom role 
and map them in this file [/operator/user-management-file-realm-secret.yaml](./operator/user-management-file-realm-secret.yaml) like this :
  
  ```yaml
    kind: Secret
  apiVersion: v1
  metadata:
    name: user-management-filerealm-secret
  stringData:
    users: |-
      es-click-admin-new:$2a$10$jqVuUtdI1n.s/46HaKsDleGRYPcznwQjfUOATHpxHRDcXA4ZPRV7a
    users_roles: |-
      click_admins_role_new:es-click-admin-new --> mapped to new role
   ```
   
once you apply the command the user will be created with customrole these users can be used to login through kibana when given appropriate permissions

* Enabling filerealm in elasticsearch : 

You can configure filerealm by editing following file  [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)

This snippet is to ingest the secrets:
```yaml
image: gcr.io/saaspoc-gtso-enterprise-gke/gkegtsoent/elastic-operator/elasticsearch:7.4.0
    auth:
      fileRealm:
      - secretName: user-management-filerealm-secret
      roles:
      - secretName: custom-role-secret
      
```
This snippet is to enable filerealm in elastic search:

```yaml
config:
   xpack.security.authc.realms.file.file1.order: 0
```
* See the vendor [LDAP Realm Configuration](https://www.elastic.co/guide/en/elasticsearch/reference/current/ldap-realm.html#ldap-realm-configuration) section in the documentation.
* Also see the venor [File Realm Configuration](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-users-and-roles.html) in the documentation.

### <a name="backup"></a>Backup Solution

* Prerequisites before using backup solution are as follows this operaotor provides two backup solutions for both the solutions these steps remains same :

1. Create a file containing the GCS credentials. For this example, name it gcs.client.default.credentials_file. The file name is important as it is reflected in the secure setting, This GCS credentials file you will get while you create a Service account, Please follow this [LINK](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) in case you face any issues while downloading this credential file.

2. The credential file which you downloaded will look like this, This file will be auto generated :

```json
{
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "...",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "service-account-for-your-repository@your-project-id.iam.gserviceaccount.com",
  "client_id": "...",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://accounts.google.com/o/oauth2/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/your-bucket@your-project-id.iam.gserviceaccount.com"
}
```
3. Create a secret in your namespace where you wish to use the backup solution using following command :

```shell
kubectl create secret generic gcs-credentials --from-file=gcs.client.default.credentials_file

```
**Note: Please use the format of service account credential file as gcs.client.default.credentials_file, do not use any extension like .json or .txt while generating a secret, the operator doesn't accept any other foramt**

4. Once the secret is created please reference the secret in here [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml).

```yaml
secureSettings:
  - secretName: gcs-credentials
```
5. Create a Google bucket Storage where all the snapshots will be stored and assign the service account storage admin permission which you have earlier created.

For your reference use the official [Documentation](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-snapshots.html) on backup.

Once the above prerequistes are met, you can use the following backup solutions: 

#### <a name="snapshot"></a>Snapshot and restore:

1. To use snapshot and restore enable gcs plugin in order to use this feature, you have to edit following file in order to install plugin [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)

```yaml
 spec:
   initContainers:
   - name: install-plugin
     command: 
     - sh
     - -c
     - |
     bin/elasticsearch-plugin install --batch repository-gcs
```
2. To use snapshot and restore in kibana follow the following [Documentation](https://www.elastic.co/guide/en/kibana/current/snapshot-repositories.html) in order to enable backup for elasticsearch indices and shards.

3. These settings need to be custom for each products team , depends on client and bucket name you are using ,  go to Snapshot and Restore under Management > Elasticsearch , create your repository which will be pointed to the gcp bucket which you have created in order to save your snapshots , following image shows the parameters you need to fill while creating the repository

![screenshot1.png](./images/screenshot1.png)

4. You can verify by clicking on verify repository to check whether all the configuration is correct or not.

![screenshot2.png](./images/screenshot2.png)

5. Now you can create a policy related to your use case which will setup the frequency on how often you need to take snapshot:

![screenshot3.png](./images/screenshot3.png)

6. Once you create the Policy you can see the snapshot in the kibana dashboard as well as google storage bucket:

![screenshot4.png](./images/screenshot4.png)

#### snapshot using cronjob

1. If you need to enable cron job and doesnt wish to use kibana snapshot and restore you can edit following file in [/operator/es-backup-cronjob.yml](./operator/es-backup-cronjob.yml)

```yaml
args: ["curl -s -i -k -u \"elastic:$(</mnt/elastic/es-basic-auth/elastic)\" -X PUT \"https://elasticsearch-config-es-http:9200/_snapshot/<bucket-name>?pretty\" -H 'Content-Type: application/json' -d' {\"type\": \"gcs\", \"settings\": { \"bucket\": \"<bucket-name>\",  \"client\": \"default\" } }' && curl -s -i -k -u \"elastic:$(</mnt/elastic/es-basic-auth/elastic)\" -X PUT \"https://elasticsearch-config-es-http:9200/_snapshot/<bucket-name>/snapshot-$(date +\"%Y-%m-%d-%H-%M\")\""]
```
* in the above snippet you have to change bucket-name and you can change the snapshot name as well and as per the requirement.

4. You can specify frequency of the job as well as you can mount the user credentials which will be used to access management APIs of elasticsearch here :

```yaml
spec:
  schedule: "@hourly"
```

```yaml
volumes:
 - name: es-basic-auth
   secret:
      secretName: <super-user-secret>
```
#### <a name="cron"></a>enable-backup-cron-job

* Once the above steps are completed regarding cron job configuration please use command enable-backup-cron-job in values.yaml and the cron job will be running as per the specifications mentioned.

### <a name="upgrade"></a>Upgrade Cluster

You can change the image tags and upgrade the version of elasticsearch using different update strategies:

To change the tags please edit the following snippet of file [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)

```yaml
version: 7.6.0
  image: gcr.io/saas-dev-us-cstack-gke1/gdu1/elastic-operator/elasticsearch:7.6.0
```
* The current versions supported are 6.8.8,7.4.0 and 7.6.0 [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)

```yaml
spec:
  updateStrategy:
    changeBudget:
      maxSurge: 3
      maxUnavailable: 1
```

You can use the updateStrategy specification to limit the number of simultaneous changes, like for example in the following cases:

The operator takes a Pod down to restart a node and applies a new configuration value.
The operator must spin up Pods above what is currently in the specification to migrate to a new node set.

* See the vendor [Update Strategy](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-update-strategy.html) documentation section.

#### <a name="pdb"></a>Pod disruption budget 

A Pod Disruption Budget allows limiting disruptions on an existing set of Pods while the Kubernetes cluster administrator manages Kubernetes nodes. Elasticsearch makes sure some indices don’t become unavailable.

A default PDB is enforced by default: it allows one Elasticsearch Pod to be taken down as long as the cluster has a green health.

This default can be tweaked in the Elasticsearch specification:

```yaml
podDisruptionBudget:
    spec:
      minAvailable: 2
      selector:
        matchLabels:
          elasticsearch.k8s.elastic.co/cluster-name: <cluster-name>
```
* See the vendor [Pod Disruption Budget](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-pod-disruption-budget.html) documentation section.

#### <a name="podafiinity"></a>Pod Affinity Options

The default affinity is using preferredDuringSchedulingIgnoredDuringExecution, which acts as best effort and won’t prevent an Elasticsearch node from being scheduled on a host if there are no other hosts available. 

the pod affinity can be tweaked for different policies in this file [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)

To enforce a strict single node per host, specify requiredDuringSchedulingIgnoredDuringExecution instead

```yaml
 podTemplate:
      spec:
        affinity:
          podAntiAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchLabels:
                  elasticsearch.k8s.elastic.co/cluster-name: elasticsearch-config
              topologyKey: kubernetes.io/hostname
```

* See the vendor [Pod Affinity](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-advanced-node-scheduling.html) documentation section.

### Setting Managed by ECK

The following Elasticsearch settings are managed by ECK:

```yaml
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

* Note, wile ECK does not prevent you from setting any of these settings yourself, you are strongly discouraged from doing so and we cannot offer support for any user provided Elasticsearch configuration that does use any of these settings.

#### Remote clusters 

* See the vendor [Remote Clusters](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-remote-clusters.html) documentation section.

#### Custom Readiness Probe

By default, the readiness probe checks that the pod can successfully respond to HTTP requests within a three second timeout.

If you wish to customize it please add following snippet in the [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)

```yaml
containers:
- name: elasticsearch
  readinessProbe:
    exec:
       command:
        - bash
        -c
        - /mnt/elastic-internal/scripts/readiness-probe-script.sh
      failureThreshold: 3
      initialDelaySeconds: 10
      periodSeconds: 12
      successThreshold: 1
      timeoutSeconds: 12
    env:
    - name: READINESS_PROBE_TIMEOUT
      value: "10"
```
### <a name="ilb"></a>Internal Load Balancer

You can use elasticsearch API service as internal load balancer by changing the following Snippet in [/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)

```yaml
#To enable internal load balancer for elasticsearch uncomment the following lines:
   http:
     service:
       metadata:   
         annotations:
           cloud.google.com/load-balancer-type: "Internal"
       spec:
         type: LoadBalancer
```

### <a name="aiops"></a>AIOPS Agent Configuration

To enable monitoring for your Elastic Search cluster you can follow these instructions on how to deploy an AIOPS APM agent along with the operator to collect the application metrics.

Pre-steps before you run the CD Pipeline:

* In **[values.yaml](./values.yaml)**, set the command field to `deployAiopsAgent: true` (This flag is applied everytime a `deploy-cluster` command is executed)
* Define with necessary configuration in **[aiops.yaml](/operator/aiops.yaml)** file and pass the values as in below code capture.
* To delete the monitoring agent along when you delete the cluster, keep the flag `deployAiopsAgent: true` while execution `delete-cluster` command.

#### <a name="aiops-config"></a>AIOPS YAML config changes

```yaml
 - resources:
            env:
              - name: APMENV_AGENTMANAGER_URL_1
                value: <AGENTMANAGER URL> -> (1)
              - name: APMENV_AGENTMANAGER_CREDENTIAL
                value: <AGENTMANAGER Token> -> (2)
              - name: APMENV_INTROSCOPE_AGENT_ELASTICSEARCH_PROFILES_CLUSTER1_NAME
                value: <CLUSTER-NAME> -> (3)
              - name: APMENV_INTROSCOPE_AGENT_ELASTICSEARCH_PROFILES_CLUSTER1_URL
                value: https://<CLUSTER-NAME>-es-http:9200/ -> (4)
              - name: APMENV_INTROSCOPE_AGENT_ELASTICSEARCH_PROFILES_CLUSTER1_USERNAME
                value: elastic
              - name: APMENV_INTROSCOPE_AGENT_ELASTICSEARCH_PROFILES_CLUSTER1_PASSWORD
                valueFrom:
                  secretKeyRef:
                    name: <CLUSTER-NAME>-es-elastic-user -> (5)
                    key: elastic
              - name: APMENV_INTROSCOPE_AGENT_ELASTICSEARCH_PROFILES_ELASTICSEARCH-CONFIG_MONITORED_GROUPS
                value: Cluster Information,Index Details,Index Summary,Node Summary, Node Index Details, Node Details,Connections
              - name: APMENV_INTROSCOPE_AGENT_ELASTICSEARCH_PROFILES
                value: cluster1
              - name: APMENV_INTROSCOPE_AGENT_AGENTNAME
                value: ElasticSearch-Monitor
              - name: APMENV_INTROSCOPE_AGENT_CUSTOMPROCESSNAME
                value: <NAMESPACE>-ElasticSearch-Monitor -> (6)
              - name: APMENV_INTROSCOPE_AGENT_HOSTNAME
                value: <NAMESPACE> -> (6)
         volumes:
        - name: login
          secret:
            secretName: <CLUSTER-NAME>-es-elastic-user (5)
```
1) The AgentManager URL is the endpoint where the agents report the polling information. The URL needs to be collected from AIOPS team based on your Tenancy/Env.
2) The Credentials shall be shared by AIOPS team based on your Tenancy/Env.
3) The cluster name specified in the elastic-search CR for Elastic Search Cluster for example - elasticsearch-config
4) The Service IP of the ElasticSearch cluster from where the APM agent will collect the appropriate metircs.
5) The default superuser secret name which is required for the secure communication between elastic cluster and apm agent.
6) Provide the Namespace where you will be deploying the cluster so that you can see group your deployments in AIOPS console.

**NOTE: If you disable xpack or disable tls, remove the user credentials and http(s) from the service url so that the APM monitoring pod can connect with the ES cluster in order to send the metrics to AIOPS console.**

### <a name="deploycurator"></a>deploy-curator

Curator can be deployed either with `deploy-cluster` command which needs the flag `deployCuratorJob: true` enabled or using `deploy-curator` which can be used incase you have kept the flag `deployCuratorJob: false` and want to deploy curator when the ES cluster is up and running, this config can be changed in **[values.yaml](./values.yaml)**

Pre-steps before you run `deploy-curator` command or enable `deployCuratorJob: true` while running `deploy-cluster` command in **[values.yaml](./values.yaml)**

* Make sure you have updated the curator config file i.e. **[curator-config.yaml](/operator/curator-config.yaml)** with regards to action and config both files are present in the mentioned configmap.

```yaml
actions:
        1:
          action: delete_indices
          description: Clean up ES by deleting old indices
          options:
            timeout_override:
            continue_if_exception: False
            disable_action: False
            ignore_empty_list: True
          filters:
          - filtertype: pattern
            kind: regex
            value: '^(alpha-|bravo-|charlie-).*$'
            #source: creation_date
            #direction: older
            #timestring: '%Y.%m.%d'
            #unit: seconds
            #unit_count: 1
            #field:
            #stats_result:
            #epoch:
            exclude: False
 ```
 * Above file can be modified in order to mention the index pattern and delete the indices which matches the same pattern, differnt filter options can be found in the following [documentation](https://www.elastic.co/guide/en/elasticsearch/client/curator/5.8/filters.html)
 * The connection credentials has been set in accordance to the cluster name please find the below file which is a part of the **[curator-config.yaml](/operator/curator-config.yaml)** for your reference
 
```yaml
 client:
        hosts:
          - elasticsearch-config-es-http   (1)
        port: 9200 
        url_prefix:
        use_ssl: True
        certificate: /etc/certificate/ca.crt (2)
        client_cert:
        client_key:
        ssl_no_validate: False
        http_auth: ${ELASTIC_CREDS} (3)
        timeout: 30
        master_only: False
      logging:
        loglevel: INFO
        logfile:
        logformat: default
```
1. The service name which will change as you change the cluster name for example in our case the cluster name is elasticsearch-            config so service name = <clustername>-es-http or elasticsearch-config-es-http
2. The crt path for ssl handshake between curator and elasticsearch
3. The default elasticsearch cluster username and password has been mounted in the **[curator-cronjob.yaml](/operator/curator-cronjob.yaml)**
 
 * The file **[curator-cronjob.yaml](/operator/curator-cronjob.yaml)** can be configured for secret mounts related to user credentials and certificates
 
```yaml
   env:
              - name: ELASTIC_USER
                value: elastic
              - name: SECRET_ES_PASSWORD
                valueFrom:
                  secretKeyRef:
                    key: elastic
                    name: elasticsearch-config-es-elastic-user
              - name: ELASTIC_CREDS
                value: $(ELASTIC_USER):$(SECRET_ES_PASSWORD)
              volumeMounts:
              - name: config
                mountPath: /etc/config
              - mountPath: /etc/certificate/secret
                name: login
              - mountPath: /etc/certificate/ca.crt
                name: certs
                subPath: ca.crt
            volumes:
            - name: config
              configMap:
                name: curator-config
            - name: login
              secret:
                secretName: elasticsearch-config-es-elastic-user
            - name: certs
              secret:
                secretName: elasticsearch-config-es-http-certs-public
```
 
 * Once the above settings are configured we can do with two options:
   * use `deployCuratorJob: true` in **[values.yaml](./values.yaml)** to deploy curator with `deploy-cluster`
   * use `deploy-curator` commad if needed to be deployed after the cluster is deployed.
   
### <a name="deletecurator"></a>delete-curator

* In order to delete curator cronjob please go ahead and put `delete-curator` in **[values.yaml](./values.yaml)** to delete the cronjob from the required namespace

### <a name="nodeattr"></a>Node Attributes

* You can use custom node attributes as awareness attributes to enable Elasticsearch to take your physical hardware configuration into account when allocating shards. If Elasticsearch knows which nodes are on the same physical server, in the same rack, or in the same zone, it can distribute the primary shard and its replica shards to minimise the risk of losing all shard copies in the event of a failure.

for example, node attributes you can use in the **[/operator/elasticsearch_cr.yaml](./operator/elasticsearch_cr.yaml)**

```yaml
 config:
        # most Elasticsearch configuration parameters are possible to set, e.g: node.attr.attr_name: attr_value
        node.master: true
        node.data: false
        node.ingest: false
        node.ml: true
        # Uncomment this parameter you can specify which topology you will like to choose , hot-warm
        #node.attr.data: hot
        node.attr.datacenter: “aws” # ”gcp” for gcp nodes
        node.attr.zone: “us-west-1a” # this value is based on the node’s region
        node.attr.box_type: “hot” #this is constant on all nodes
```
As soon as the specific attributes has been assigned we can use pod-affinity rules to make sure the node spins up in the zone specified or the box_type as hot/warm etc, look into this section for [Pod Affinity](#podafiinity)

## <a name="automation-of-project-id-and-environment-variable"></a>automation of project-id and environment variable
No need to change the project-id and environment variable every where. Just have to change the image in [values.yaml](./values.yaml). The image in the yaml files in [operator](./operator) folder will reflect the same automatically.
[values.yaml](./values.yaml)
```
 image:
  repository: gcr.io/saaspoc-gtso-enterprise-gke/gkegtsoent/elastic-operator/elasticsearch-operator
 
 ```
project-id = saaspoc-gtso-enterprise-gke
 and environment name= gkegtsoent

documentaion: [shard-allocation-awareness](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-cluster.html#shard-allocation-awareness), [node-attr-api](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-nodeattrs.html)
 
