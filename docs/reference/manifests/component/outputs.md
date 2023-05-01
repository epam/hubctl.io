# Section `outputs`

To bind input parameters of the `pgweb` to specific PostgreSQL, use `depends`:

```yaml
outputs:
- name: ingress.hosts                     # mandatory, name of output parameter
  brief: Ingress FQDN                     # optional, propagated to stack level outputs
  value: ${dns.name}.${dns.baseDomain}    # optional, either `value` or `fromTfVar` must be defined
  fromTfVar: fqdn                         # optional, either `value` or `fromTfVar` must be defined
  kind: secret/token                      # optional, secret/<kind> is the only supported variation
```

When more than a single instance of the same component is deployed in the stack - think two PostgreSQL databases, then there is an ambiguity because both components provides same outputs, ie. `endpoint` and `password`.

Where `brief` and `kind` will be propagated to stack level outputs if component:output syntax is used on hub.yaml level.

## Computed Outputs

When you need to output parameters from the deployment script (`deploy.sh`). Use the following syntax:

```bash

cat << EOF

Outputs:
server_uptime = $(uptime)

EOF
```

And then link this with the `hub-component.yaml`:

```yaml
outputs:
- name: message.uptime
  fromTfVar: server_uptime
```

Hubctl component deployment reads stdout for a specific Terraform like pattern. Once detected, it will capture response.

## Outputs from File

To read outputs from a file use the following syntax, where parameter value prefixed with `file://`. See example below:

```yaml
outputs:
- name: message.uptime
  fromFile: file://uptime.txt
```

## See Also

* [Component Manifest](../)
* [Stack Outputs](../../stack/outputs)
