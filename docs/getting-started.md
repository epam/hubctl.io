# Getting Started

This page will show how to start using Hub CTL

## Installation

### Pre-build binary

To download the latest release, run:

#### cURL

```shell
curl -LJ "https://github.com/epam/hubctl/releases/latest/download/hubctl_$(uname -s)_$(uname -m).tar.gz" \|
  tar xz -C /tmp && sudo mv /tmp/hubctl /usr/local/bin
```

#### Wget

```shell
wget "https://github.com/epam/hubctl/releases/latest/download/hubctl_$(uname -s)_$(uname -m).tar.gz" -O - |\
  tar xz -C /tmp && sudo mv /tmp/hubctl /usr/local/bin
```

#### Other pre-build binaries

There are [macOS amd64](https://github.com/epam/hubctl/releases/latest/download/hubctl_Darwin_arm64.tar.gz), [macOS arm64](https://github.com/epam/hubctl/releases/latest/download/hubctl_Darwin_x86_64.tar.gz), [Linux amd64](https://github.com/epam/hubctl/releases/latest/download/hubctl_Linux_arm64.tar.gz), [Linux arm64](https://github.com/epam/hubctl/releases/latest/download/hubctl_Linux_x86_64.tar.gz) and [Windows x64](https://github.com/epam/hubctl/releases/latest/download/hubctl_Windows_x86_64.zip) binaries.

### [Homebrew](https://brew.sh/) Formula

```shell
brew tap epam/tap
brew install epam/tap/hubctl
```

### Extensions

Optionally, install extensions:

```shell
hubctl extensions install
```

Hub CTL Extensions requires: [bash], [curl], [jq] and [yq v4].
Optionally install [Node.js] and NPM for `hubctl pull` extension, [AWS CLI], [Azure CLI], [GCP SDK] [kubectl], [eksctl] for `hubctl ext eks` extension.

[AWS CLI]: https://aws.amazon.com/cli/
[Azure CLI]: https://docs.microsoft.com/en-us/cli/azure/
[GCP SDK]: https://cloud.google.com/sdk/docs/install
[kubectl]: https://kubernetes.io/docs/reference/kubectl/overview/
[eksctl]: https://eksctl.io
[jq]: https://stedolan.github.io/jq/
[yq v4]: https://github.com/mikefarah/yq
[Node.js]: https://nodejs.org
[bash]: https://www.gnu.org/software/bash
[curl]: https://curl.se
