# Section `parameters`

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

## Resolve parameter value

Here we specify parameter types and their interpretation.

This is the most common type of parameter. It is used to set parameter value to a literal:

```yaml
parameters:
- name: kubernetes.namespace
  value: kube-system
```

with interpolation
```yaml
parameters:
- name: dns.domain
  value: example.com
- name: ingress.hosts
  value: www.${dns.domain}
  # resolves to: www.example.com
```

or multiline parameters

```yaml
parameters:
- name: ingress.hosts
  value: |
    example.com
    www.example.com
```

### Parameter `fromEnv`

> __Stack Level only__

This parameter only forks for stack manifests (`hub.yaml` and `params-*.yaml`). It allows to set parameter value from environment variable:

```yaml
parameters
- name: kubernetes.namespace
  fromEnv: NAMESPACE
  default: kube-system
```

Parameter above will set value of parameter `kubernetes.namespace` to value of environment variable `NAMESPACE`

During `hubctl stack configure` user will be prompted to provide value for parameter `kubernetes.namespace` with default value `kube-system`.

### Parameter `env`

> __Component Level only__

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

## CEL expressions

Parameter `value` support [CEL expressions](https://github.com/google/cel-go) enclosed in `#{}` such as:

```yaml
parameters:
- name: cloud.availabilityZones
- name: cloud.availabilityZones.count
  value: "#{len(cloud.availabilityZones)}"
```

> CEL has some unexpected results for corner cases, use `hubctl cel` to debug.

## Parameter `kind`

All parameters can be derived from primarily from values or other components. These parameters resolved during the deployment. Until you are not care for specific parameter __kind__ then leave it out.

However there are special case parameters. In this case you define a special attribute `kind` to specify how parameter should be resolved.

### Parameter `kind: user`

There are high-level user-provided parameters - the facts `user` do care about: which cloud and cloud account to use, what region to deploy to, etc.

### Parameter `kind: link`

In general, preferred approach to resolve parameters provided as outputs from the component is through `components.depends` attribute. However sometimes you need to change parameter name as they are not match.

To map output to a different name use `kind: link` parameter. The interpretation of `value` will be deferred until parameter is used:

```yaml
parameters:
- name: backend.image
  value: ${ecr:docker.image}
  kind: link
```

`ecr` is a component deployed prior to `backend`. There are several ECRs thus output is fully qualified.

## See also

* [Stack Manifest](../../stack)
* [Component Manifest](../)
* [CEL expressions](https://github.com/google/cel-go)
