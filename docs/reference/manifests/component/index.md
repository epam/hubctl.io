# Hubfile Reference

On top level stack manifest contains following sections:

```yaml
meta:
    kind: stack 
    version: 1
requires:                              # optional, list of requirements for stack
    - kubernetes
components:
    - name: cert-manager               # mandatory, name of the component
      source:
        dir: components/cert-manager   # mandatory, local path where to find component
    - name: knative-serving
        source:
            dir: components/knative-serving
        git:                                      # optional, git source to download component from
            remote: https://github.com/agilestacks/kubeflow-components.git # git repository remote url
            subDir: knative-serving               # mandatory, subdirectory in the repository
            ref: develop                          # optional, git reference (branch, tag, commit)
        depends:                                  # optional, component dependency
        - cert-manager
    lifecycle:                                    # optional, lifecycle verbs
        verbs:
            - deploy                              # mandatory, deploy verb
            - undeploy                            # mandatory, undeploy verb
            - custom-verb                         # optional, custom verb
        order:                                    # optional, order of deployment
            - cert-manager
            - knative-serving
    parameters:
        - name: dns.domain                         # mandatory, parameter name
          value: localhost                         # mandatory, parameter name
        - name: certmanager.namespace
          component: cert-manager                  # optional, component name, if not defined then parameter is global for all components
          brief: Define namespace for cert-manager # optional, brief description for parameter
          default: v1.11.0                         # optional, default value for parameter
          fromEnv: CERTMANAGER_NAMESPACE           # optional, parameter value is taken from environment variable, this approach allows not to store exact value in version control. Useful for sensitive parameters.
    outputs:                                    # optional, stack outputs
    - name: foo                                 # mandatory, output name
      value: http://localhost:${pgweb.port}     # mandatory, output value
      brief: foo endpoint                       # optional, brief description for output       
```

# Component manifest:

- [meta](./meta): name, description, version, etc.
- [requires](./requires) and [provides](./provides)
- [parameters](../parameters.md): inputs, defaults, mapping to OS environment
- [outputs](./outputs)
- [templates](./templates): where are the templates
- [lifecycle](./lifecycle): verbs, fine-tuning for hubctl




### Requires and provides

```yaml
requires:
- aws

provides:
- devops
```

### Lifecycle

```yaml
lifecycle:
  verbs:
  - deploy
  - undeploy
  order:
  - kubernetes
  - traefik
  - kube-dashboard
  # by default every component is mandatory until `mandatory` block exist,
  #     then everything else is optional
  # so use either `mandatory` or `optional`
  mandatory:
  - kubernetes
  optional:
  - kube-dashboard
  requires:
    optional:  # see Lifecycle > Deploy > Optional requirements
    - vault
  readyConditions:
  - dns: api.${dns.domain}              # resolvable
    url:  https://api.${dns.domain}/v1  # returns something other than HTTP 500
    waitSeconds: 600  # how long to wait for the condition
    pauseSeconds: 0   # pause before starting poll loop
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

## See Also

* [Stack Manifest](../stack)
