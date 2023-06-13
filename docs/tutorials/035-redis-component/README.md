# Create Helm Component

This tutorial will guide you through the process of creating a Helm component. We will use Redis, an in-memory data store, as an example.

## Stack structure

The stack and component directory structure is as follows:

```text
.
├── components                           # Directory with components
│    └── redis                           # Directory with Redis-related configurations
│        ├── charts                      # Directory contains helm charts archives
│        ├── backup                      # Script to backup redis data
│        ├── hub-component.yaml          # Parameters definitions
│        ├── post-deploy                 # Post deploy script to restore data from backup file if provided
│        ├── values-auth.yaml.template   # Redis auth helm values template
│        └── values.yaml.template        # Base helm values template
├── hub.yaml
└── params.yaml        
```

## Component structure

Each component has to know how to deploy itself and export facts about deployment configuration in the well-known form of parameters. So other component would use this as an input.

Hub component contains the following:

1. `hub-component.yaml` - file with input and output parameters
2. As we are going to use `helm` we don't have to provide provisioning script `deploy` and `undeploy`.
3. `backup`, `post-deploy` you can specify these scripts for backup/restore. They are omitted at this tutorial


In the nutshell - parameters defined in `hub-component.yaml` abstracts user from concrete provisioning technology and allows maintainer of the component improve or even change provisioning technology without breaking compatibility with the other components.

## Deploy a minimalistic component

1. Create a new directory `components/redis`
2. Create a file `components/redis/hub-component.yaml` 
3. In order to use helm we have to specify requirements: `helm` and `kubernetes`
4. Then we have to specify kubernetes namespace, for example: `redis`
5. Specifying component-specific parameters, for Redis in minimalistic way we set username/password, for example: `test`
6. For Helm we point out repository, chart version and values we want to use

```yaml
version: 1
kind: component

requires:
  - kubernetes
  - helm

parameters:
  - name: hub.componentName
    env: COMPONENT_NAME
  - name: storage.class
    empty: allow
  - name: redis
    parameters:
      - name: namespace
        value: redis
        env: NAMESPACE
      - name: port
        value: 6379
      - name: username
        value: test
      - name: password
        value: test

  - name: helm
    parameters:
      - name: repo
        value: https://charts.bitnami.com/bitnami
        env: HELM_REPO
      - name: chart
        value: redis
        env: HELM_CHART
      - name: version
        value: 17.11.3
        env: HELM_CHART_VERSION
      - name: valuesFile
        value: values.yaml
        env: CHART_VALUES_FILE

templates:
  files:
    - "*.template"

lifecycle:
  verbs:
    - deploy
    - undeploy
```

1. Add a component reference to Hubfile (`hub.yaml`)
2. Set required technologies
3. Include parameters file

```yaml
kind: stack
version: 1

requires:
  - kubernetes
  - helm
  - 
components:
- name: redis
  source:
    dir: components/redis

extensions:
  include:
    - params.yaml
```

Then create a new parameters file params.yaml with the following

```yaml
parameters:
- name: kubernetes.context
  value: rancher-desktop
- name: dns.domain
  value: localhost
- name: storage.class
  brief: |
    Name of the existing Kubernetes storage class.
    This class will be used to provision PVs for Kubeflow such and notebooks and databases

    To check for available storage classes run: `kubectl get sc`
  fromEnv: STORAGE_CLASS
```

You are now ready to run a deployment from the directory where hub.yaml is located.

```bash
hubctl stack init 
hubctl stack deploy
```

If deployment went successfully, you are able to get created containers 

```bash
docker ps | grep redis
bcbc1e768483   0383c71164bc                           "/bin/bash -c /opt/b…"   19 minutes ago      Up 19 minutes                k8s_redis_redis-replicas-2_redis_ab402c47-2986-4f00-9167-c970481ec50a_0
c170a048c969   rancher/mirrored-pause:3.6             "/pause"                 19 minutes ago      Up 19 minutes                k8s_POD_redis-replicas-2_redis_ab402c47-2986-4f00-9167-c970481ec50a_0
bd2a014383c7   0383c71164bc                           "/bin/bash -c /opt/b…"   19 minutes ago      Up 19 minutes                k8s_redis_redis-replicas-1_redis_2c7fa2ac-0f22-4771-90b4-31a57db039c7_0
c85c52901bc9   rancher/mirrored-pause:3.6             "/pause"                 19 minutes ago      Up 19 minutes                k8s_POD_redis-replicas-1_redis_2c7fa2ac-0f22-4771-90b4-31a57db039c7_0
70d7a5aa6978   0383c71164bc                           "/bin/bash -c /opt/b…"   20 minutes ago      Up 20 minutes                k8s_redis_redis-master-0_redis_13989399-ee2f-4a07-9376-e866bd8c62f1_0
637659151ce7   0383c71164bc                           "/bin/bash -c /opt/b…"   20 minutes ago      Up 20 minutes                k8s_redis_redis-replicas-0_redis_f7da61b8-c7ca-4530-b5b6-270a1f22c5e5_0
9038c6cc7033   rancher/mirrored-pause:3.6             "/pause"                 20 minutes ago      Up 20 minutes                k8s_POD_redis-master-0_redis_13989399-ee2f-4a07-9376-e866bd8c62f1_0
db1e1c2a29ef   rancher/mirrored-pause:3.6             "/pause"                 20 minutes ago      Up 20 minutes                k8s_POD_redis-replicas-0_redis_f7da61b8-c7ca-4530-b5b6-270a1f22c5e5_0

```

We can see 4 redis pods with 1 master and 3 replicas have been created
Let's connect to master pod and insert some data. Firstly authenticate using username we specified in `hub-component.yaml`. Then set some key-value

```bash
docker exec -it $REDIS_MASTER_CONTAINER_ID redis-cli

redis-master> AUTH test
OK
redis-master> set ping pong
OK
redis-master> get ping
"pong"
redis-master> exit
```

After that connect to any replica container. And check a value we set.

```bash
docker exec -it $REDIS_REPLICA_CONTAINER_ID redis-cli

redis-replica> AUTH test
OK
redis-replica> get ping
"pong"
redis-replica> exit
```

Replica pod successfully returns value.

