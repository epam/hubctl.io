# Section `outputs`

Stack outputs can be defined as the following

```yaml
outputs:
- name: ingress.hosts                     # mandatory, name of output parameter
  brief: Ingress FQDN                     # optional, meaningful description
  value: ${dns.name}.${dns.baseDomain}    # mandatory, output of a stack
```

## See Also

* [Stack Manifest](../)
* [Component Outputs](../../component/outputs)
