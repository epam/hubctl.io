# Install

This page will show how to install hubctl on your local workstation

There are few ways to install hubctl:

1. Download binary
2. Homebrew Formula

## Download binary

To download the latest of hubctl run the following

### cURL

```shell
curl -LJ "https://github.com/epam/hubctl/releases/latest/download/hubctl_$(uname -s)_$(uname -m).tar.gz" \|
  tar xz -C /tmp && sudo mv /tmp/hubctl /usr/local/bin
```

### Wget

```shell
wget "https://github.com/epam/hubctl/releases/latest/download/hubctl_$(uname -s)_$(uname -m).tar.gz" -O - |\
  tar xz -C /tmp && sudo mv /tmp/hubctl /usr/local/bin
```

## [Homebrew](https://brew.sh/) Formula

```shell
brew tap epam/tap
brew install epam/tap/hubctl
```

## Extensions

Extensions are the plugins for hubctl. It provides additional functionality to hubctl. To install extensions run:

```shell
hubctl extensions install
```

There are few common tools used across all extensions. Other tools are component specific

* [bash]
* [curl]
* [jq]
* [yq v4]

### Optional dependencies

Some components and extensions requires additional tools to be installed:

* [AWS CLI] - for components that requires `aws`
* [Azure CLI] - for component that requires `azure`
* [Gcloud SDK] - for component that requires `gcp`
* [kubectl] - for components that requires `kubernetes`
* [Terraform] - for components that requires `terraform`
* [Helm] - for components that requires `helm`
* [Kustomize]*
* [Node.js] - to activate `hubctl pull` extension
* [Docker CLI] - to active `hubctl toolbox` extension

> Special note for [Kustomize]: by default kustomize has been shipped together with [kubectl] (`kubectl -k ...`) However if user has a [kustomize] installed. Hubctl will use it instead.

## What's Next

* See our Getting Started [guide](/tutorials/)

[AWS CLI]: https://aws.amazon.com/cli/
[Azure CLI]: https://docs.microsoft.com/en-us/cli/azure/
[Gcloud SDK]: https://cloud.google.com/sdk/docs/install
[kubectl]: https://kubernetes.io/docs/reference/kubectl/overview/
[jq]: https://stedolan.github.io/jq/
[yq v4]: https://github.com/mikefarah/yq
[Node.js]: https://nodejs.org
[bash]: https://www.gnu.org/software/bash
[curl]: https://curl.se
[Terraform]: http://terraform.io
[Helm]: https://helm.sh
[Kustomize]: https://kustomize.io
