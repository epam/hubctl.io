# Kubernetes Component

Kubenretes is a far popular technology to run containers. We do love Kubernetes and provide  first class support with the `hubctl`. So `hubctl` will manage access credentials and provide naming conventions for Kubernetes.

## When component requires kubenretes

Here we provide conventions required for component if it requires kubenretes. These conventions repeat conventions for [helm extensions](/hubctl/components/helm) and [kustomize extensions](/hubctl/components/kustomize)

File `hub-component.yaml` of the component should require `kubernetes` and expose few of the parameters as the environment variabels

```yaml
requires:
- kubernetes
parameters:
- name: kubernetes.namespace # this parameter name can be anything
  value: kube-system         # this is example of kubenretes namespace
  env: NAMESPACE
```

More about required parameters has been described below

> Note: kubeconfig should exist before, kubernetes cluster context should match to the `dns.domain` of your stack

### Input parameters

As every script, helm deployment scripts has been controlled via set off well-known environment variables. These variables should be defined in parameters section of `hub-component.yaml`. List of expected environment variables

| Variable   | Description | Required | Passed from `.env`
| :-------- | :-------- | :-: | :--:
| `HUB_DOMAIN_NAME` | Hub naming convention requires `dns.domain` parameter to match to kubeconfig context that corresponds to the stack, fallbacks to legacy `DOMAIN_NAME` env var. If not defined in `hub-component.yaml` manifest will be derived from stack | x |
| `NAMESPACE` | Target kubernetes namespace | x |

There are additional environment variables, depends on your cloud type

### Kubeconfig helper script

Because components de-facto has been deployed by the shell scripts. So it is natural to provide helper functionality for Kubernetes in the form of script as well.

`bin/kubeconfig` is a script that helps with kubeconfig management. This sript has been available in the `PATH` of every component that has been deployed.

* `kubeconfig cp` - writes to stdout (or file) the extracted copy of a one context and user credentials. It will rename to the value of (`HUB_STACK_DOMAIN`) to follow to the `hubctl` conventions for kubernetes.
* `kubeconfig test` - will test connectivity to the kubernetes cluster

## When component provides kubenretes

This is useful when component actually deploys a new instance of the Kubenretes cluster. Then the component has been responsible to provide outputs of a kubenretes cluster in a standard form (standard output parameters and kubeconfig). So, this can be used by following components in the runlist that __requires kubernetes__. This is a bit of extra effort but it will also ensure that component that requires kubernetes (and possible written by someone else) will know how to get deployed into the Kubenretes cluster providen by your component

There are various ways how Kubenretes cluster can be deployed. So, information in the `hub-component.yaml` file will be different

### Example for `GKE`

The minimalistic GKE cluster should provide following

```yaml
provides:
- kubernetes
outputs:
  - name: dns.domain
  - name: kubernetes.gke.cluster
  - name: kubernetes.api.endpoint
```

## Common Parameters

Kubernetes components expects common soft interface. Soft means `hubctl` wont mandate user to require one or few parametrs from the table below. However such common form help you to build a well-designed component. So, user of the component would know what to expect from the component that requires `kubernetes`

| Parameter   | Description | Possible Value
| :-------- | :-------- | :--:
| `kubernetes.namespace` | Target kubernetes namespace. Usually bound to `NAMESPACE` environment variable | `kube-system`
| `kubernetes.serviceAccount` | Name of the service account to be used by the component | `default`
| `kubernetes.replicas` | Number of replicas for the component | `1`
| `kubernetes.requests` | List of whitespace separated `key=value` pairs to be used by component as a resource requests | `cpu=100m memory=128Mi`
| `kubernetes.limits` | List of whitespace separated `key=value` pairs to be used by component as a resource limits | `cpu=100m memory=128Mi`
| `kubernetes.labels` | List of whitespace separated `key=value` pairs to be used by component as a labels | `app=nginx instance=nginx`
| `kubernetes.annotations` | List of whitespace separated `key=value` pairs to be used by component as a annotations | `app=nginx instance=nginx`
| `ingress.class` | Kubernetes ingress class name. If empty then configured default will be used | `nginx`
| `ingress.hosts` | List of whitespace separated hosts to be configured in ingress. Empty value means no igress needed | `myservice.example.com anotherservice.example.com`
| `ingress.protocol` | Instructs if TLS configuration should be used for ingress | `https` or `http`
| `storage.class` | Kubernetes storage class name. If empty then configured default will be used | `gp2`
| `storage.size` | Size of the persistent storage to be allocated | `10Gi`

## How to use `key=value` pairs

1. Define parameter see example:

```yaml
parameters:
- name: kubernetes.requests
  value: >-
    cpu=100m 
    memory=128Mi
```

2. Define a gotemplate file with the following content. For instance `values.yaml.gotemplate` that will look like the following

```yaml
resources:
  requests:
{{- range .kubernetes.requests | splitList " "}}
    {{. | replace "=" ": "}}
{{- end}}
```

This will produce the following output

```yaml
resources:
  requests:
    cpu: 100m
    memory: 128Mi
```

## See also

* [Hub Components](../)
* [Component Helm](../helm)
* [Component Kustomize](../kustomize)
