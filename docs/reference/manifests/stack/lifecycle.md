# Section `lifecycle`

```yaml
lifecycle:                             # optional
  verbs:                               # optional, verbs supported by stack (if omited, then limited to verbs deploy and undeploy)
  - deploy          
  - undeploy
  order:                               # optional, user defined order of components in which it must be deployed. If omitted then order will be derived form component dependencies followed by component order in stack manifest
  - kubernetes                         # example names of components
  - traefik
  - kube-dashboard
  mandatory:                           # optional, list of mandatory components. by default all components are optional
  - kubernetes
  optional:                             # optional, list of optional components. by default all components are optional
  - kube-dashboard
  requires:                             # optional, section to define optional rquirements
    optional:                           # see Lifecycle > Deploy > Optional requirements
    - vault
  readyConditions:                      # optional, list of conditions to check before component is considered ready
  - dns: api.${dns.domain}              # resolvable
    url:  https://api.${dns.domain}/v1  # returns something other than HTTP 500
    waitSeconds: 600                    # how long to wait for the condition
    pauseSeconds: 0                     # pause before starting poll loop
```
