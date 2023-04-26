# Section `lifecycle`

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
