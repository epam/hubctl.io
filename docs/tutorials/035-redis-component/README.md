# Create Helm Component

This tutorial will guide you through the process of creating a Helm component. You will use Redis, an in-memory data store, as an example.

## Stack structure

The stack and component directory structure is as follows:

```text
.
├── components                           # Directory with components
│    └── redis                           # Directory with Redis-related configurations
│        ├── hub-component.yaml          # Component manifest
│        └── values.yaml.template        # Base helm values template
└──  hub.yaml                            # Stack manifest

```

## Component structure

Each component has to know how to deploy itself and export facts about deployment configuration in the well-known form of parameters. So other component would use this as an input.

Hubctl component contains the following:

1. `hub-component.yaml` - file with input and output parameters
2. As you are going to use `helm` you don't have to provide provisioning script `deploy` and `undeploy`.

In the nutshell - parameters defined in `hub-component.yaml` abstracts user from concrete provisioning technology and allows maintainer of the component improve or even change provisioning technology without breaking compatibility with the other components.

## Deploy a minimalistic component

1. Create a new directory `components/redis`
2. Create a file `components/redis/hub-component.yaml`
3. In order to use helm we have to specify requirements: `helm` and `kubernetes`
4. Then you have to specify kubernetes namespace, for example: `redis`
5. Specifying component-specific parameters, for Redis in minimalistic way you set username/password
6. For Helm you point out repository, chart version and values you want to use

```yaml
kind: component                                                # mandatory, defines a component manifest
version: 1                                                     # mandatory, manifest schema version

requires:                                                     # optional, list of environment requirements
  - kubernetes
  - helm

parameters:
  - name: redis                                               # parameter name of redis
    parameters:
      - name: namespace                                       # redis parameter name of namespace [redis.namespace]
        value: redis                                          # value for namespace parameter
        env: NAMESPACE                                        # environment variable of namespace
      - name: port                                            # redis parameter name of port [redis.port]
        value: 6379                                           # value for port parameter
      - name: username                                        # redis parameter name of username [redis.username]
        fromEnv: REDIS_USER                                   # optional, parameter value is taken from environment variable, this approach allows not to store exact value in version control.
      - name: password                                        # redis parameter name of password [redis.password]
        fromEnv: REDIS_PASSWORD                               # if the variable does not exist in the .env file and Hubctl prompts the user to enter a value and will save it in .env file.
  - name: helm                                                # parameter name of helm
    parameters:
      - name: repo                                            # helm parameter name of repo [helm.repo]
        value: https://charts.bitnami.com/bitnami             # instructs hubctl to download helm chart from the helm repository
        env: HELM_REPO                                        # environment variable HELM_REPO
      - name: chart                                           # helm chart resolved via variable HELM_CHART
        value: redis                                          # this can have multiple values, that corresponds to the helm chart location
        env: HELM_CHART                                       # environment variable HELM_CHART


templates:
  files:                                                      # mandatory, list of template files, supports globs
    - "*.template"                                            # template files in current component directory
```

Read more about Helm [here](../../reference/components/helm/)

1. Add a component reference to Hubfile (`hub.yaml`)
2. Set required technologies, parameters and extensions

```yaml
kind: stack                                                 # mandatory, defines a stack manifest
version: 1                                                  # stack manifest schema version

requires:                                                   # optional, list of environment requirements
  - kubernetes
  - helm

components:                                                 # mandatory, list of components
  - name: redis                                             # mandatory, name of the component
    source:                                                 # mandatory, component source
      dir: components/redis                                 # mandatory, local path where to find component

parameters:                                                 # optional, stack input parameters (best practice, split to separate file or files)
  - name: kubernetes.context                                # mandatory, parameter name [kubernetes.context]
    value: rancher-desktop                                  # optional, value of parameter

extensions:                                                 # optional
  configure:                                                # optional, steps activated during `hubctl stack configure`
    - kubernetes
    - env
```

You are now ready to run a deployment from the directory where hub.yaml is located.
The following commands are used for this:

- `hubctl stack init` - this command initializes the working directory with the `hub.yaml` file.
```shell
hubctl stack init
```

- `hubctl stack configure` - stack configuration before deployment
```shell
hubctl stack configure
```

- `hubctl stack deploy` - Runs a deployment for the entire stack, or updates the deployment of one or more components.
```shell
hubctl stack deploy
```

If the deployment status is deployed and the `redis` component is completed, you can to list of the namespaced objects, such as our pod `redis`. To do this, run the following command:

```shell
kubectl get pods --namespace=redis
```

You can see 4 redis pods with 1 master and 3 replicas have been created:

```text
# NAME               READY   STATUS
# redis-master-0     1/1     Running
# redis-replicas-2   1/1     Running
# redis-replicas-1   1/1     Running
# redis-replicas-0   1/1     Running
```

### Conclusions

In this tutorial, you created the Helm component. You configure the minimalistic component with using Redis, an in-memory data store, as an example.
You deployed it and made sure the new component was done.

