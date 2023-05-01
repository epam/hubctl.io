# Hubfile Reference

On top level stack manifest contains following sections:

```yaml
kind: component                            # mandatory, defines a component manifest                         
version: 1                                 # mandatory, manifest schema version
meta:                                      # optional, see Meta        
  name: foo-component                      # optional, component name
  brief: Foo component                     # optional, brief description of the component        
  license: Apache 2.0                      # optional, license applied to component distribution
requires:                                  # optional, list of requirements for component can be provided by environment (stack), or another component
- gcp                                      # example of component requirement
- terraform                                # example of component requirement
provides:                                  # optional, list of capabilities provided by component
- bucket                                   # example of component capability
parameters:
- name: hub.componentName                  # optional, special parameter that always bounds to component name defined in `hub.yaml`
- name: bucket.name                        # mandatory, parameter name
  value: ${hub.componentName}              # example, shows how to default 
  env: TF_VAR_name                         # optional, mapping to environment variable for use deployment script
- name: bucket.region                      # example, shows mandatory paramer that have now default value
- name: gcp.serviceAccount
  empty: allow                             # example shows optional parameter that ca nbe empty
outputs:                                   # optional, list of outputs provided by component
- name: bucket.endpoint                    # mandatory, output name
  value: https://storage.googleapis.com    # example, shows predefined output, parameter interpolation syntax is supported
  breif: Well-knows GCP bucket endpoint    # optional, brief description for output
- name: bucket.region                      
  fromTfVar: location                      # example, shows how to map output to terraform variable
- name: bucket.accessKey
  fromTfVar: sensitive_access_key_id       # example, shows how to map output to sensitive variable
- name: bucket.name                        # example, shows how to forward component parameter to output
templates:                                 # optional, list of templates provided by component
  kind: curly                              # mandatory, other values [mustache, go]
  files:                                   # mandatory, list of template files, supports globs
  - "*.template"                           # example of template files in current 
lifecycle:
  verbs:                                   # optional, add custom verbs for `hub invoke`. Defaults to [deploy, undeploy]
  - deploy
  - undeploy
  - backup                                  
  bare: true                                # optional, instruction to allow component without deploy or undeploy implementation
  readyConditions:                          # optional, conditions to check before declaring component deployed
  - dns: api.${dns.domain}                  # optional, checks if dns name has been resolved
    url:  https://api.${dns.domain}/v1      # optional, uses http ping GET to check if url is available
    pauseSeconds: 0                         # optional, pause in seconds before starting poll loop

```

# Component manifest:

Component manifest section described on more details

- [meta](./meta): name, description, version, etc.
- [requires](./requires) 
- [provides](./provides)
- [parameters](./parameters.md): inputs, defaults, mapping to OS environment
- [outputs](./outputs)
- [templates](./templates): where are the templates
- [lifecycle](./lifecycle): verbs, fine-tuning for hubctl

## See Also

* [Stack Manifest](../stack)
