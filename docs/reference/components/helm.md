# Helm Component

Helm is a popular packaging technology for Kubernetes applications. We do provide our own opinionated way how to deploy helm components.

## Component Conventions

If component follows the conventions below, then hubctl will know how to deploy it.

### Helm Detection

When you want to use helm deployment add the following definition to the `hub-component.yaml`

```yaml
requires:
- kubernetes
- helm
```

and place one one of the following files in the component directory: `values.yaml`, `values.yaml.template` or `values.yaml.gotemplate`

Then hubctl will be able detect this component as helm component and call provisioning script: [helm-component-deploy](https://github.com/epam/hub-extensions/blob/master/hub-component-helm-deploy) .

### Input parameters

As every script, helm deployment scripts has been controlled via set off well-known environment variables. These variables should be defined in parameters section of `hub-component.yaml`. List of expected environment variables

| Variable   | Description | Required
| :-------- | :-------- | :-: |
| `DOMAIN_NAME` | [FQDN](https://en.wikipedia.org/wiki/Fully_qualified_domain_name) of a stack. We use this parameter as a natural id of the deployment (defaults to implicit variable `HUB_DOMAIN_NAME`). Usage of this variables requires user to define a parameter `dns.domain` in `hub-component.yaml`. Yet we advice to use instead an implicit variable `HUB_DOMAIN_NAME` instead |  |
| `COMPONENT_NAME` | Corresponds to parameter `hub.componentName` parameter, however can be overriden in `hub-component.yaml`. Hub will use this variable as a helm release name | x |
| `NAMESPACE` | Target kubernetes namespace | x |
| `HELM_CHART` | This can have multiple values, that corresponds to the helm chart location. Corresponds to the helm chart tar url, tarball, directory or a chart name in the repository | x |
| `HELM_REPO` | Instructs hubctl to download helm chart from the helm repository | |
| `HELM_CHART_VERSION` | Addes a version constraint to the helm chart install. This variable works in conjunction with `HELM_REPO` | |
| `HELM_CHART_USERNAME` and `HELM_CHART_PASSWORD`| Username and password for helm chart repository basic auth | |
| `CHART_VALUES_FILE` | Instructs hubctl that it must use concrete values file inside of the helm chart as the base and only override with parameters from `values.yaml` in the component root directory. Alternatively if this variable has prefix `http` or `https` then the file. Additional values files can be referenced by adding a whitespace (or new line) separated reference | |
| `CRD` | URL or local path to the CRD file (if not located in `<component root>/crds` directory)  | |
| `HELM_OPTS` | Helm command arguments, defautls to `--create-namespace --wait` | |

#### Environment variable: `HELM_CHART`

Helm chart which user wants to deploy can be resolved via variable `HELM_CHART`. This variable corresponds to the following value:

* Path to the local directory with the helm chart (relative to the `<component root>` or `<component root>/charts` directory)
* Path to the local directory with the helm chart (relative to the `<component root>` or `<component root>/charts` directory )
* Name of the helm chart in the helm repository (requires user to define: `HELM_REPO` and `HELM_CHART_VERSION`)

### Deployment hooks

User can define pre and post deployment

* `pre-deploy` or `pre-deploy.sh` to trigger action before helm install
* `post-deploy` or `post-deploy.sh` to trigter action after successful helm install
* `pre-undeploy` or `pre-undeploy.sh` to trigger action before helm delete
* `post-undeploy` or `post-undeploy.sh` to trigger action after helm successful delete

> Note: pre and post deployment scripts should have execution rights

### Custom Resources

We do advise not to deploy CRD with the helm chart. Because component `undeploy` (and `helm delete` correspondingly) will also delete CRDs. Deletion of CRD will also delete custom resources that may have been deployed by the user after this component has been deployed. Instead we advise to put your CRDs in to the `<component root>/crds` directory. In this case, CRDs will be managed separately from the helm chart

1. CRDs will be deploymed before the helm chart
2. CRDs will not be deleted after component will be undeployed. Which means you can redeploy the component without dropping user custom resources

## Examples

Nginx web server example. This is an example of a `hub-component.yaml` that will install a helm chart without any modifications. Complete code for nginx component can be found [here](https://github.com/epam/hub-google-components/tree/main/nginx)

```yaml
---
version: 1
kind: component
requires:
  - kubernetes
  - helm
provides:
  - nginx
  - ingress
parameters:
  - name: ingress.namespace
    value: ingress
    env: NAMESPACE
  - name: ingress.class
    value: nginx
  - name: helm
    parameters:
      - name: chart
        value: nginx-ingress
        env: HELM_CHART
      - name: repo
        value: https://helm.nginx.com/stable
        env: HELM_REPO
      - name: version
        value: 0.13.2
        env: HELM_CHART_VERSION
templates:
  files:
    - values.yaml.template
```

> Note: helm chart parameters values must be defined in the `values.yaml.template` alternatively you can run `values.yaml.gotemplate` file

## See also

* [Hub Components](../)
* [Kubernetes Configuration](../kubernetes/)
