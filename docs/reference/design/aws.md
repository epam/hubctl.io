# Amazon Web Services

In order to deploy Hubctl components using AWS, you'll need to meet the following prerequisites:

- AWS account
- AWS Profile with S3 Read/Write access, if hubctl deployment state is preferred to be stored remotely
- AWS Profile with Route53 Read/Write access, if domain name registration is required

## Parameters

Table below lists all the parameters and environment variables that can be used to configure.

| Environment Variable | Description                                     |
|----------------------|-------------------------------------------------
| `HUB_DOMAIN_NAME`    | Domain name of the stack.                       |
| `HUB_STACK_NAME`     | Name of the stack. Prefix part of  `dns.domain` |
| `AWS_REGION`         | AWS Region, default `us-east-1`                 |
| `AWS_PROFILE`        | AWS Profile                                     |

## Hubctl steps

In order to use AWS configuring scripts, in `hub.yaml` at `extensions` defining of steps is required.

```yaml
extensions:
  init:
    - aws
  configure:
    - aws
```

### Hubctl init

Hubctl aws init checks if AWS profile configured. Defines AWS profile and region for stack.

Hubctl can init stack from existing state file stored in some https or S3 endpoint.

```shell
hubctl stack init s3://<aws-account-id>.superhub.io/melted-odyssey-792/hub/simple-aws/hub.state
```

See more about [`init`](../../../hubctl/cli/hubctl-stack-init)

### Hubctl configure

`hubctl stack configure` works with parameters listed in table below

| Configure parameters      | Environment Variable          | Description                                                                                     |
|---------------------------|-------------------------------|-------------------------------------------------------------------------------------------------
| --aws-region              | `AWS_REGION`                  | AWS Region (defaults to value from: AWS_REGION)                                                 |
| --domain-name             | `HUB_DOMAIN_NAME`             | Custom DNS domain name under existing base domain                                               |
| --base-domain-aws-profile | `HUB_BASE_DOMAIN_AWS_PROFILE` | AWS Profile for base domain (in case base domain hosted zone is located in another AWS account) |
| --bubbles-secret-key      | `HUB_DOMAIN_SECRET`           | DNS manager secret                                                                              |
| --dns-update              | `DNS_ACTION`                  | Action request to DNS manager                                                                   |
| --prefer-local            | `PREFER_LOCAL_STATE`          | Save deployment state locally only                                                              |
| --output                  | `DOT_ENV`                     | Environment variables file                                                                      |
| --dry-run                 | `DRY_RUN`                     | Do not deploy cloud resources, show what will happen                                            |
|                           | `HUB_STATE_BUCKET`            | Name of the bucket for hub state store                                                          |
|                           | `ZONE_ID`                     | AWS zone for configured domain                                                                  |
|                           | `HUB_CLOUD_PROVIDER`          | Tells hubctl to use different backends for terraform. Here will be set: `aws`                   |

Configuring uses AWS profile and region that were defined at init phase\
If the `HUB_STATE_BUCKET` variable is not defined, S3 bucket with name the AWS account ID and suffix `.superhub.io` will
be created.
In case local storing preference isn't true, hubctl state will be located in that S3 bucket.

For DNS accessibility configures Route53 by checking for the presence of the hosted zone specified in `HUB_DOMAIN_NAME`.
If it is not found, by default deploys it using Bubbles DNS manager. This web service able to provide ephemeral
environments for temporary usage.
Otherwise, if `DNS_MANAGER` is "user", checks for the presence of the parent domain and its hosted zone. If the parent
hosted zone is found,
updates the nameservers for the child domain. If neither the parent nor the child hosted zone is found,
exits with an error message.

See more on how to configure DNS Bubbles in the [DNS Bubbles configuration](../dns).

See more about [`configure`](../../../hubctl/cli/hubctl-stack-configure)
