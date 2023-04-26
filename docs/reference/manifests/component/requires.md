# Section `requires`

```yaml
requires:
- aws
- kubernetes
```

Component does not live in the vacuum. Some components expects certain capabilities provided by the upstream component or the environment

Built-in requirements:

- `aws`
- `azure`
- `gcp`
- `kubernetes`
- `helm`
- `terraform`

Component can define a requirement provided by another component. These requirements are not limited to the list above
