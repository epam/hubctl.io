# Section `provides`

This is a high level instruction to broadcast to the other components that after this component has been deployed, there is a new capability (or capabilities).

```yaml
provides:     # optional
- bucket      # example of provided capability
```

Capability is an arbitrary string. This string will be recognized by the other component in [requires](../requires) section.

## Access Provides from Component

When component wants to check capabilities provided by environment or by other component. It can use:

- Well-known environment variable `HUB_PROVIDES` - same format as above.
- Well-known parameter `hub.provides` - whitespace separated list of capabilities

Where parameter is a good choice for `deploy.sh` or `pre-deploy.sh`, or deployment hooks scripts. While parameter can be checked for instance by `gotemplate`

## Best Practice

Both `provides` and `requires` component maintainers agree on the exact capability string. They also agree on well-defined `outputs` which component will provide together with the capability. In the other words `requires` and `provides` defines mutual contract between components on what parameters to expect from each other.

For instance, when component provides capability `bucket` it should also provide following outputs:

```yaml
outputs:
- name: bucket.endpoint
- name: bucket.region
- name: bucket.name
- name: bucket.accessKey
- name: bucket.secretKey
```

This will make such components as [minio](https://github.com/epam/hub-kubeflow-components/tree/main/minio) and [gsbucket](https://github.com/epam/hub-google-components/tree/develop/gsbucket) virtually interchangeable.

There are a lot of parameters. You don't need all of them to output. Some parameters can be consumed by the input. However, component that will require either `minio` or `gsbucket`, it may expect these parameters will be provided.

## See Also

* [Requires](../requires)
* [Component Manifest](../)
