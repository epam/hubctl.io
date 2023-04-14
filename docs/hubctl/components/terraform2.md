# Terraform Component

Terraform is a popular infrastruture as code technology often used to deploy cloud resources. We do provide our own opinionated way how to deploy Terraform. In this case you can follow simple conventions and you don't require to write a deployment scripts

## Component Conventions

If component follows the conventions below, then hubctl will know how to deploy  it.

Minimalistic terraform component will look like this:

Hubctl will automatically detect Terraform code when component contains one or more `*.tf` files.

```text
./
├── hub-component.yaml  # component manifest
└── main.tf             # terraform code
```

### Configuration

Terraform variables can be supplied in two ways:

1. Terraform variables can be defined by component parameter and exported as `TF_VAR_*` environment variable (recommended way)
2. Terraform variables can be defined in `*.tfvars` or `*.tfvars.template` file


## Parameters

As every script, helm deployment scripts has been controlled via set off well-known environment variables. These variables should be defined in parameters section of `hub-component.yaml`. List of expected environment variables

| Variable   | Description | Required | Passed from `.env`
| :-------- | :-------- | :-: | :--:
| `COMPONENT_NAME` | Corresponds to parameter `hub.componentName` parameter, however can be overriden in `hub-component.yaml`. Hub will use this variable as a helm release name | x | |
| `HUB_DOMAIN_NAME` | [FQDN](https://en.wikipedia.org/wiki/Fully_qualified_domain_name) of a stack. We use this parameter as a natural id of the deployment | x | x |
| `HUB_CLOUD_PROVIDER` | Tells hubctl to use different backends for terraform. We currently support: `aws`, `azure` or `gcp` | x | x |
| `HUB_STATE_BUCKET` | Object storage bucket to be be used for terraform state  | x | x |
| `HUB_STATE_REGION` | Region for terraform state bucket  | x | x |

There are additional environment variables, depends on your cloud type

#### AWS specific variables

These variables has been set during `hubctl stack configure` state and defined in `.env` file. You don't have to refer it for your component, however you can overwrite.

| Variable   | Description | Required
| :-------- | :-------- | :-: |
| `AWS_PROFILE` | AWS name of the profile. Referenced from `.env` file. However you can override it in `hub-component.yaml` file | x |

### Azure specific variables

These variables has been set during `hubctl stack configure` state and defined in `.env` file. These are the minimum viable variables expected by our terraform deploymenet script

| Variable   | Description | Required
| :-------- | :-------- | :-: |
| `ARM_CLIENT_ID` | The client(application) ID of an App Registration in the tenant | |
| `ARM_CLIENT_SECRET` | A client secret that was generated for the App Registration | |
| `ARM_SUBSCRIPTION_ID` | Access an Azure subscription value from within a Terraform script | |
| `ARM_TENANT_ID` | ARM Tenant id | |

Full list of environment variables for azure can be found here: https://www.terraform.io/docs/language/settings/backends/azurerm.html

### GCP specific variables

| Variable   | Description | Required
| :-------- | :-------- | :-: |
| `GOOGLE_APPLICATION_CREDENTIALS` | Default applicaiton credentials (ADC) see details [here](https://cloud.google.com/docs/authentication/production) | |
| `GOOGLE_PROJECT` | For to refer google project ID. See details [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#full-reference) | |

Full reference of supported variables available here: https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#full-reference

## Deployment hooks

User can define pre and post deployment

* `pre-deploy` to trigger action before helm install
* `post-deploy` to trigter action after successful helm install
* `pre-undeploy` to trigger action before helm delete
* `post-undeploy` to trigger action after helm successful delete
* `import` a special script that to import existing resources into Terraform state.

> Note: `import` maybe a necessary step to allow manage non-idempotent resources such as AWS S3 bucket. Before running terraform deployment that will fail you may want to import bucket if it already exists.

> Note: deployment hooks should have execution rights 

## See also

* [Hub Components](/hubctl/components)
