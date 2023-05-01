# Outputs

When more than a single instance of the same component is deployed in the stack - think two PostgreSQL databases, then there is an ambiguity because both components provides same outputs, ie. `endpoint` and `password`.

To bind input parameters of the `pgweb` to specific PostgreSQL, use `depends`:

```yaml
components:
- name: pg1:
  source: components/postgresql
- name: pg2:
  source: components/postgresql
- name: pgweb1:
  source: components/pgweb
  depends:
  - pg1
```
