# Command: `hubctl stack configure`

Reads configuration information in one or multiple hubfiles referenced by the command `hubctl stack init` and applies configuration before the stack deployment.

When hubfile will require parameter supplied bia environment variable (`fromEnv`) ,for instance passwords or access credentials, then this command will save value for this variable in `.env` file. You can change this value later by modifying `.env` file.

Upon completion of configure command execution will ensure that all stack input parameters has been defined.

## Configuration requirements

Input parameters can be supplied by various scripts. Which exactly and it's order has been defined in hubfile via requirements

```yaml
extensions:
  configure:
  - env
  - gcp
```

List of supported requirements for configuration

| Requirement   | Description |
| :-------- | :-------- |
| `gcp` | Configures stack for deployment to GCP. Will bootstrap a DNS zone (optionally relying to bubble dns service) and a GCS bucket to store state |
| `aws` | Configures stack for deployment to AWS. Will bootstrap a Route53 zone (optionally relying to bubble dns service) and a S3 bucket to store state. This will make sure that credentials has been reachable for the deployment |
| `azure` | Similar to `aws` and `gcp` will configure stack for Microsoft Azure Cloud deployment |
| `env` | Ensures that all environment variables (`fromEnv`) has been defined by the user  |
| `kubernetes` | Reserved when user already have got a running Kubernetes cluster. This requirement may conflict if stack will actually deploy a new cluster. This requirement will ensure that kubernetes credentials stored in kubeconfig has been reachable by the kubeconfig by creating py of just one kube-context in `.hub/env` directory |
| `components` | DEPRECATED. Functionality of this requirement has been moved to  `hubctl stack init` command |
| `backup` | Activate backup/restore functionality for the stack (note that at least one component should accept verb `backup`) |

## Command Parameters

These parameters applies across all extension commands. If hubfile contains additional requirements then there may be additional command parameters

### Common parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-r --requirement <arg>` | Specific one or multiple (this parameter can repeat) requirements to apply for reconfiguration. If no requirements provided, then this means all requirements as specified in hubfile | |
| `--profile <arg>` | Set specific deployment profile | |
| `-V --verbose` | extra verbosity for diagnostics | |
| `-h --help` | print help and usage message | |

### Google Cloud Platform

Flags specific to `gcp` parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `--gcp-project-id  <arg>` | Override project id in `.env` file | |
| `--gcs-bucket-name  <arg>` | Override GCS bucket name (defaults to: `gs://<project_id>-superhub`) | |
| `--domain-name <arg>` | Instructs to use a specific domain name (otherwise will be autogenerated by bubble DNS service) | |

### Amazon Web Services

Flags specific to `aws` parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `--aws-region <arg>` | Use specific AWS region (otherwise default from AWS profile will be used) | |
| `--aws-profile <arg>` | Use specific AWS profile (otherwise current or default profile will be used) | |
| `--aws-profile <arg>` | Use specific AWS profile (otherwise current or default profile will be used) | |
| `--domain-name <arg>` | Instructs to use a specific domain name (otherwise will be autogenerated by bubble DNS service) | |
| `--base-domain-aws-profile <arg>` | To address case when parent hosted zone managed in different AWS account | |
| `--prefer-local` | Instructs not to use hubctl state in S3 bucket | |
| `--dns-update` | Instructs bubble DNS service to update TTL on existing DNS record (instead of requesting new random record) | |
| `--bubbles-secret-key <arg>` | User provides bubble dns secret that will proof his ownership on stack. Otherwise value from .env file will be used | |

### Microsoft Azure Cloud

Flags specific to `azure` parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `--azure-region <arg>` | Use specific Azure region (otherwise default from AWS profile will be used) | |
| `--azure-resource-group <arg>` | Azure Resource Group (defaults to value from: `AZURE_RESOURCE_GROUP_NAME`, `AZURE_DEFAULTS_GROUP` environment variables) | |
| `--azure-subscription <arg>` | Azure Resource Group (defaults to value from: `AZURE_SUBSCRIPTION_ID`) | |
| `--base-domain-resource-group <arg>` and `--base-domain-subscription <arg>` | To address case when parent hosted zone managed in different AWS account | |
| `--prefer-local` | Instructs not to use hubctl state in S3 bucket | |
| `--dns-update` | Instructs bubble DNS service to update TTL on existing DNS record (instead of requesting new random record) | |
| `--bubbles-secret-key <arg>` | User provides bubble dns secret that will proof his ownership on stack. Otherwise value from .env file will be used | |

### Environment Variables

Flags specific to `env` parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-f --file <arg>` | Ask for variables from only specific hubfiles (defaults to `HUB_FILES` variable in `.env` file,  can repeat multiple time) | |
| `--defaults` | Instructs not to confirm user input for environment variables (reserved for non-interactive usage, such as CI server) | |

### Kubernetes

Flags specific to `kubernetes` parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `--kubeconfig <arg>` | Path to kubeconfig. Otherwise `KUBECONFIG` environment variable will be used. | |
| `--kubecontext <arg>` | Use specific context inside kubeconfig. Otherwise current will be used | |
| `--current-kubecontext` or `--kubecontext _` | Explicitly says to use current kube-context | |

> Note: If you want to run configure from the pod (inside kubernetes). This extension configure stack to rely on service account of the pod

### Components (deprecated)

Please use new command: `hubctl stack init` instead

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-f --file <arg>` | Instructs to use specific hubfiles (defaults to `HUB_FILES` variable in `.env` file,  can repeat multiple time) | |
| `-c --component <arg>` | Ask to download a specific component only (can repeat multiple times, defaults to all components defined in hubfiles) | |
| `--override` | Write over files if component already exists | |

> Note: If you want to run configure from the pod (inside kubernetes). This extension configure stack to rely on service account of the pod

## DYI Configuration

Can I build my own configuration script for my custom case? Or override behavior of existing one? Yes just follow couple of simple steps

1. Create file: `<working-dir>/.hub/<requirement>/configure` and add execution rights
2. Write your script using: `shell` (preferably), `bash` or general purpose language of your choice.
3. Add reference to the hub.yaml

```bash
# example
mkdir -p ".hub/mysuperextension"
touch ".hub/mysuperextension/configure"
chmod +x ".hub/mysuperextension/configure"
```

then feel free to add reference that looks like the following to the `hub.yaml`

```yaml
extensions:
  configure:
  - mysuperextension
```

## Usage Example

Configure stack before deployment

```bash
hubctl stack configure
```

Reload GCP configuration, and refresh TTL for bubble DNS service

```bash
hubctl stack configure -r "gcp"
```

Configure refresh kubeconfig for kubernetes cluster (if access rotated)

```bash
hubctl stack configure -r "kubernetes"
```

## See also

* [`hubctl stack init`](../hubctl-stack-init)
* [`hubctl stack deploy`](../hubctl-stack-deploy)
* [`hubctl stack`](../hubctl-stack)
