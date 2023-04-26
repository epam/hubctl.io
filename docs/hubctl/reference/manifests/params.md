# Parameters Reference

Parameters are used to configure stack and components in both stack manifest (`hub.yaml`) and component manifest (`hub-component.yaml`).

Parameters have a tree-like structure where leafs have values and nodes should have nested parameters:

```yaml
parameters:
- name: cloud.kind
  value: aws                          # set to value provided by user
- name: cloud.regions                 # this parameter is only set for component `foo`
  component: foo                      
  value: [us-east-1, us-east-2]
- name: kubernetes                    # nested parameters for kubernetes 
  parameters: 
  - name: worker.size
    fromEnv: KUBERNETES_WORKER_SIZE   # Source value form environment variable
    default: m5.large                 # Use default if value not provided
```

Native YAML syntax could be used to short-circuit nested declarations. The above is effectively flattened into list of parameters:

```text
cloud.kind
cloud.regions
kubernetes.worker.size
```

The values are in most cases plain text / scalar type, yet we support arrays and maps - data types native to JSON and YAML.

## Parameter types

Here we specify parameter types and their interpretation.

### Parameter `fromEnv`

This parameter only forks for stack manifests (`hub.yaml` and `params-*.yaml`). It allows to set parameter value from environment variable:

```yaml

```yaml
- name: kubernetes.namespace
  fromEnv: NAMESPACE
  default: kube-system
```

Parameter above will set value of parameter `kubernetes.namespace` to value of environment variable `NAMESPACE`

During `hubctl stack configure` user will be prompted to provide value for parameter `kubernetes.namespace` with default value `kube-system`. 

### Parameter `env`

This parameter only works for component manifests (`hub-component.yaml`). It allows to set environment variables from parameter value:

```yaml
parameters:
- name: kubernetes.namespace
  env: NAMESPACE
  value: kube-system
```

Parameter above will define environment variable `NAMESPACE` with value `kube-system` as a default (unless stack will provide different name)

### Parameter `fromFile`

Parameter value could be read from file `fromFile: config/stage/password`.

### Parameter `kind`

There are high-level user-provided parameters - the facts `user` do care about: which cloud and cloud account to use, what region to deploy to, etc.

There are also lower-level technical parameters, which hubctl must derive from other places, such as backend service endpoint which may come from another stack or from component output.

By default all parameters are technical

## Mapping

Some parameters cannot be resolved at beginning of the deployment. To map output to a different name use `kind: link` parameter. The interpretation of `value` will be deferred until parameter is used:

```yaml
- name: component.backend.image
  value: ${backend-ecr:component.ecr.image}
  kind: link
```

`backend-ecr` is a component deployed prior to `backend`. There are several ECRs thus output is fully qualified.

## CEL expressions

Parameter `value` support [CEL] expressions enclosed in `#{}` such as `Cloud region is ${cloud.region} and number of availability zones is #{len(cloud.availabilityZones)}.

CEL has some unexpected results for corner cases, use `hub cel` to debug.

## See also

* [Stack Manifest](stack.md)
* [Component Manifest](component.md)
