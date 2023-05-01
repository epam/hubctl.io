# Hubfile

Sometimes called as hub manifest. is a YAML file that describes a stack or a component. It is a source of truth for hubctl deployment. We will use both names interchangeably.

There are two types of manifests:

* Component manifest: `hub-component.yaml`
* Stack manifest: `hub.yaml`, `params.yaml`

## [Component manifest](./component)

Component manifest describes how to deploy a component:

* Component `requires` (that the component expects from environment or another (upstream) component)
* Component `provides` what capability component will add to the stack (e.g. `kubernetes` or `bucket`)
* Component input `parameters`:
  - names, defines interface for the component
  - defaults 
  - mapping to OS environment variables (to the deployment scripts)
* Component `outputs` (to be used as inputs by downstream components)
* Component `lifecycle`
  - verbs (besides `deploy` and `undeploy`) that can be executed on the component
  - readiness probes
* Describes `templates` used by the component

See more about component manifest in [here](component.md).

## [Stack manifest](./stack)

Stack manifest describes how one or multiple components are deployed together:

* Stack `requires` from environment
* Describes `components` list and dependencies between them
* Describes stack input `parameters`
  - names
  - values,
  - Mapping from OS environment variables and default values
* Describes deployment `hooks`

### Component references

```yaml
components:
- name: storage-class
  source:
    dir: components/storage-class
    git:  # optional, to maintain `dir` as subtree of the Git repo with `hub pull`
      remote: 'https://github.com/agilestacks/components.git'
      ref: master
      subDir: storage-class
  depends:  # optional, search order to match parameters to outputs
  - kubernetes
```


### Requires and provides

```yaml
requires:
- aws

provides:
- devops
```


### Parameters

```yaml
parameters:
- name: cloud.region
  brief: Cloud region
  value: us-east-2
  # parameter value might be set separately for each component
  component: external-dns
  kind: user    # if value is not set then user will be asked interactivelly to provide value
  default: aws  # if user parameter value is not provided then the default will be used
  empty: allow  # if value is not set then it is not an error, empty string is assigned
  fromEnv: AWS_REGION  # capture user parameter value from OS environment
  # read from file
  fromFile: config/secret
  # a special case to read file pointed by OS env var `ENV` or `hub deploy -e ENV=...`
  # this is not an expression, only $ as first character triggers redirection
  fromFile: $ENV

# final name is `cloud.kind` and the kind is `user`
- name: cloud
  kind: user
  parameters:
  - name: kind
    value: aws
```

For convenience, `parameters` could be nested so that parent `name` is prepended and attributes such as `empty: allow` and `kind: user` are inherited. `elaborate` will annotate `fromEnv` parameters with `kind: user`.

`value` supports substitution expressions such as `${cloud.region}` or `1 ${var2} 3 ${var4}` and `#{}` [CEL expressions], see Component manifest > Parameters below.

#### Mapping

Some parameters cannot be resolved at beginning of the deployment. To map output to a different name use `kind: link` parameter. The interpretation of `value` will be deferred until parameter is used:

```yaml
- name: component.backend.image
  value: ${backend-ecr:component.ecr.image}
  kind: link
```

`backend-ecr` is a component deployed prior to `backend`. There are several ECRs thus output is fully qualified.

### Stack outputs

```yaml
outputs:
- name: component,ingress.fqdn
  brief: Ingress FQDN
  description: >
    ...
  value: ${component,ingress.fqdn}  # optional, defaults to `${name}`
  kind: secret/token  # optional, secret/<kind> is the only supported variation
# or from a specific component
- name: kubernetes:dns.domain
```

### Extensions

This section is used by [Hub CLI extensions]. Hub CLI will verify the structure of this block but will ignore it.

```yaml
extensions:
  include:
  - params.yaml
  - params/env.yaml
  configure:
  - aws
  - kubernetes
  deploy:
    before:
    after:
    - inventory-configmap
  undeploy:
    before:
    after:
```

## Component manifest

`hub-component.yaml` is a canonical name for component manifest.

### Meta

```yaml
version: 1
kind: component
meta:
  name: dex
  title: Dex
  brief: Dex OIDC and OAuth2 provider
  description: >
    ...
  category: Edge Proxy
  version: 2.26.0
  maturity: ga  # beta alpha
  license: Apache 2.0
```

### Requires and provides

```yaml
requires:
- kubernetes

provides:
- ingress
```

### Lifecycle

```yaml
lifecycle:
  verbs:  # add custom verbs for `hub invoke`
  - deploy
  - undeploy
  bare: true  # set to allow components without deploy or undeploy implementation
              # usefull for creating synthetic outputs
  readyConditions:
  - dns: api.${dns.domain}              # resolvable
    url:  https://api.${dns.domain}/v1  # returns something other than HTTP 500
    waitSeconds: 600  # how long to wait for the condition
    pauseSeconds: 0   # pause before starting poll loop
  options:
    random:
      bytes: 128  # see Manifest > Outputs > Securing outputs
```

### Parameters

```yaml
parameters:
- name: cloud.region
  brief: Cloud region
  value: us-east-2  # default value to use if not passed from stack level parameter
  empty: allow      # if value is not set then it is not an error, empty string is assigned
  env: AWS_REGION   # set OS environment
```

#### CEL expressions

Parameter `value` support [CEL] expressions enclosed in `#{}` such as `Cloud region is ${cloud.region} and number of availability zones is #{len(cloud.availabilityZones)}.

CEL has some unexpected results for corner cases, use `hub cel` to debug.

### Component outputs

```yaml
outputs:
- name: component,ingress.fqdn
  brief: Ingress FQDN
  value: ${dns.name}.${dns.baseDomain}
  fromTfVar: fqdn  # either `value` or `fromTfVar` must be defined
  kind: secret/token  # optional, secret/<kind> is the only supported variation
```

`brief` and `kind` will be propagated to stack level outputs if `component:output` syntax is used on `hub.yaml` level.

### Templates

```yaml
templates:
  kind: curly  # mustache go
  directories:
  - config
  files:
  - "*.template"
  extra:
  - kind: mustache
    files:
    - terraform/*.tf.template
  - kind: go
    files:
    - helm/values*.yaml.gotemplate
```

[Hubctl extensions]: https://github.com/epam/hub-extensions
[CEL]: https://github.com/google/cel-go
