# Stack Manifest

Stack manifest describes how one or multiple components are deployed together. It a either a `hub.yaml` file or combination of `hub.yaml` and `parameter-*.yaml` files.

```yaml
meta:
  kind: stack                                                     # mandatory, defines a stack manifest
  version: 1                                                      # stack manifest schema version
requires:                                                           # optional, list of requirements form environment
- kubernetes
components:
- name: cert-manager                                            # mandatory, name of the component
  source:
    dir: components/cert-manager                                # mandatory, local path where to find component
- name: knative-serving
    source:
      dir: components/knative-serving
    git:                                                        # optional, git source to download component from
      remote: https://github.com/epam/kubeflow-components.git # git repository remote url
      subDir: knative-serving                                 # mandatory, subdirectory in the repository
      ref: develop                                            # optional, git reference (branch, tag, commit)
    depends:                                                  # optional, component dependency
    - cert-manager
lifecycle:                                                    # optional, lifecycle verbs
  verbs:
  - deploy                                                  # mandatory, deploy verb
  - undeploy                                                # mandatory, undeploy verb
  - custom-verb                                             # optional, custom verb
  order:                                                    # optional, order of deployment
  - cert-manager
  - knative-serving
parameters:
- name: dns.domain                                          # mandatory, parameter name
  value: localhost                                          # optional, value for parameter
- name: certmanager.namespace
  component: cert-manager                                   # optional, component name, if not defined then parameter is global for all components
  default: v1.11.0                                          # optional, default value for parameter
  fromEnv: CERTMANAGER_NAMESPACE                            # optional, parameter value is taken from environment variable, this approach allows not to store exact value in version control. Useful for sensitive parameters.
- name: ingress.hosts
  empty: allow                                              # optional, to highlight parameter that can be empty
  fromEnv: INGRESS_HOSTS                                    # good idea to pass value for empty parameters from environment variable
  brief: Lorem ipsum                                        # optional, brief description for parameter

outputs:                                                    # optional, stack output parameters
- name: foo                                                 # mandatory, output name
  value: http://localhost:${pgweb.port}                     # mandatory, output value, supports interpolation
  brief: Lorem ipsum                                        # optional, brief description for output       
```

## Sections of stack manifest

Here we will describe each section of stack manifest in more detail

### Section: `meta`

This section defines metadata for the stack manifest. Metadata can be captured by automation tools

```yaml
version: 1             # mandatory, stack manifest schema version
kind: stack            # mandatory, defines a stack manifest
meta:
  name: happy-meal     # optional         
  title: Happy Meal    # optional
  brief: Lorem ipsum   # optional
  description: |
    optional, multiline description
  fromStack: ../../stacks/base-stack  # see FromStack
  license: Apache 2.0  # optional, license applied to stack distribution
```

Every stack must define at least manifest `version` and `kind`. Other fields are optional.

Section `meta.fromStack` can enable inheritance of stack manifest from another stack. This will enable stack to inherit parameters values from another stack.

### Section `requires`

Stack does not live in the vacuum. There are certain capabilities it requires from the environment before it ca nbe deployed. Some examples of requirements:

- Cloud kind: `aws`, `azure`, `gcp`;
- `kubernetes` cluster connectivity

```yaml
requires:
- aws
- kubernetes
```

### Section `components`

```yaml
components:
- name: external-dns
  source:
    dir: components/external-dns
    git:
      remote: https://github.com/epam/hub-kubeflow-components.git
      ref: main
      subDir: external-dns
  depends:
  - cert-manager
```

Above you can see `external-dns` component sources are under `./components/external-dns/` directory.

Section `components.source.git` section is optional. If not specified then `hubctl stack init` will not pull the component from git repository if this component does not exist. This operation happens during `hubctl stack init`

Section `components.depends` defines dependency between components. This takes effect on the:

- Components deployment run-list `hubctl` will schedule component deployment in the order of dependency and then in order of declaration. User can overwrite order by declaring section `lifecycle.order` in stack manifest.
- Parameters resolution. Let's say there are two components who output the same parameter. Section `depends` will tell to `hubctl` which component parameters must be taken as input.

## Section `parameters`

This section is common between stack and component manifests. It defines parameters that can be used in the stack or component manifests. See more details in [Parameters Reference](./parameters)

## See also

* [Parameters Reference](./parameters)
* [Component Manifest](./component)

