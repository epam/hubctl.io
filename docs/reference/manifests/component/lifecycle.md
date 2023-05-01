# Section `lifecycle`

Lifecycle, is a set of instructions to hubctl to control component deployment

```yaml
lifecycle:
  verbs:                                # optional, add custom verbs for `hub invoke`. Defaults to [deploy, undeploy]
  - deploy
  - undeploy
  bare: true                            # optional, instruction to allow component without deploy or undeploy implementation
  readyConditions:                      # optional, conditions to check before declaring component deployed
  - dns: api.${dns.domain}              # optional, checks if dns name has been resolved
    url:  https://api.${dns.domain}/v1  # optional, uses http ping GET to check if url is available
    pauseSeconds: 0                     # optional, pause in seconds before starting poll loop
  options:                              # optional
    random:                             # optional
      bytes: 128                        # optional, see Manifest > Outputs > Securing outputs
```

## See Also

* [Component Manifest](../)
