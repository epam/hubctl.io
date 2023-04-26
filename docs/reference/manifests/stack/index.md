# Stack Manifest

Stack manifest describes how one or multiple components are deployed together. It a either a `hub.yaml` file or combination of `hub.yaml` and `parameter-*.yaml` files.

Below you will find compolete stack manifest example

```yaml
meta:
  kind: stack                                                 # mandatory, defines a stack manifest
  version: 1                                                  # stack manifest schema version
requires:                                                     # optional, list of requirements form environment
- kubernetes                                                  # example of stack requires
components:                                                   # mandatory, list of components
- name: cert-manager                                          # mandatory, name of the component
  source:                                                     # mandatory, component source
    dir: components/cert-manager                              # mandatory, local path where to find component
- name: knative-serving
    source:
      dir: components/knative-serving
    git:                                                      # optional, git source to download component from
      remote: https://github.com/epam/kubeflow-components.git # mandatory, git repository remote url
      subDir: knative-serving                                 # mandatory, subdirectory in the repository
      ref: develop                                            # optional, git reference (branch, tag, commit)
    depends:                                                  # optional, component dependency
    - cert-manager                                            # example of upstream dependency
lifecycle:                                                    # optional, lifecycle verbs
  verbs:                                                      # optional, list of verbs component supports (by default: deploy, undeploy)
  - deploy                                                    # mandatory, deploy verb
  - undeploy                                                  # mandatory, undeploy verb
  - custom-verb                                               # optional, custom verb
  order:                                                      # optional, order of deployment
  - cert-manager                                              # example of deployment order, if not defined then deployment order derived from components definitions
  - knative-serving
parameters:                                                   # optional, stack input parameters (best practice, split to separate file or files)
- name: dns.domain                                            # mandatory, parameter name
  value: localhost                                            # optional, value for parameter
- name: certmanager.namespace
  component: cert-manager                                     # optional, component name, if not defined then parameter is global for all components
  default: v1.11.0                                            # optional, default value for parameter
  fromEnv: CERTMANAGER_NAMESPACE                              # optional, parameter value is taken from environment variable, this approach allows not to store exact value in version control. Useful for sensitive parameters.
- name: ingress.hosts
  empty: allow                                                # optional, to highlight parameter that can be empty
  fromEnv: INGRESS_HOSTS                                      # good idea to pass value for empty parameters from environment variable
  brief: Lorem ipsum                                          # optional, brief description for parameter
outputs:                                                      # optional, stack output parameters
- name: foo                                                   # mandatory, output name
  value: http://localhost:${pgweb.port}                       # mandatory, output value, supports interpolation
  brief: Lorem ipsum                                          # optional, brief description for output       
```

> Note: if optional section defined, it may have mandatory attributes

Follow each section separately to get more details:

* [meta](./meta): name, brief
* [components](./components) references: what and where are the components
* [requires](./requires) and provides
* [parameters](./parameters): stack inputs, mappings
* [outputs](./outputs) of a stack
* [lifecycle](./lifecycle): verbs, optional and mandatory components, conditional deployment
* [extensions](./extensions): verbs, optional and mandatory components, conditional deployment

## See Also

* [Component Manifest](./component)

