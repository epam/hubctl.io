# Section `lifecycle`

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

