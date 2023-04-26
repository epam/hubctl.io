# Hubctl Manifest

On top level stack manifest contains following sections:

```yaml
meta:
    kind: stack 
    version: 1
requires:                              # optional, list of requirements for stacj
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

* meta: name, brief
* components references: what and where are the components
* requires and provides
* lifecycle: verbs, optional and mandatory components, conditional deployment
* parameters: stack inputs, mappings
* stack outputs

# Component manifest:

- meta: name, description, version, etc.
- requires and provides
- lifecycle: verbs, fine-tuning for Hub CLI
- parameters: inputs, defaults, mapping to OS environment
- component outputs
- templates: where are the templates

Hub CLI `elaborate` verifies manifests according to the [schema](https://github.com/epam/hubctl/blob/master/meta/manifest.schema.json).

For high-level introduction see [[Manifest]].


## Stack manifest

`hub.yaml` is a canonical name for stack manifest.

### Meta

```yaml
version: 1
kind: stack
meta:
  name: happy-meal
  title: Happy Meal
  brief: Kubernetes with monitoring and DevOps tools
  description: >
    ...
  fromStack: ../../stacks/base-stack  # see FromStack
```

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

### Component lifecycle hooks

Sometimes before or after a component deployment, SREs need to perform an action that extends the component and often is environment or context-specific. To achieve that component lifecycle hooks were introduced. This approach allows keeping components KISS and if-less. Please refer to the example below:

```yaml
components:
- name: external-dns
  hooks:
  - file: bin/do-something              # relative to the directory where the hugctl manifest file is located (`hub.yaml`)
    brief: Some description of my hook  # optional, brief description for hook
    error: ignore                       # optional, default is `error: fail`
    triggers:                           # optional, default is `triggers: [pre-deploy, post-deploy]`
    - pre-deploy
    - post-undeploy
  source:
    dir: components/external-dns
```

There are 2 hooks in the example:

* File `pre-deploy-hook` from the `.hub` directory relative to the directory where the Hub manifest file is located (`hub.yaml`) will be executed BEFORE `external-dns` component is deployed. `error: ignore` means that stack deployment will continue even if there is an error in the hook (it exits with non 0 exit code)
* File `post-deploy-hook` from the `.hub` directory relative to the directory where the Hub manifest file is located (`hub.yaml`) will be executed AFTER `external-dns` component is deployed.

Additionally,

* `triggers` array also supports regular expressions, such as `*-deploy` or `post-*`
* All hooks matching the expression will be executed, and hook order from the `hooks` list will be maintained.

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

[Hub CLI extensions]: https://github.com/epam/hub-extensions
[CEL]: https://github.com/google/cel-go
