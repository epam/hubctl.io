#  Create Amazon S3 component with Terraform

This tutorial shows you how to create an Amazon S3 bucket hubctl component using Terraform.

## In This Tutorial

The tutorial covers the following topics:

* How to configure the simple Amazon S3 hubctl component 
* How to configure Terraform for this AWS component 
* How to deploy the stack with Amazon S3 components using Terraform

## About

At the first, let's understand what is the minimum configuration for Amazon S3 component with Terraform.

```text

├── components                           # Directory with components
│    └── s3-bucket                       # Directory with configurations
│        ├── hub-component.yaml          # Component manifest
│        ├── import                      # Special script that to import existing resources into Terraform state
│        └── main.tf                     # Terraform code
└── hub.yaml                             # Stack manifest
```
Read more about Terraform Component [here](../../../reference/components/terraform/)

- A specific configuration defining a stack manifest in `hub.yaml` is the first thing needed. Such a file describes the components and options for deployment.

```yaml
kind: stack                                               # mandatory, defines a stack manifest
version: 1                                                # stack manifest schema version
  
requires:                                                 # optional, list of environment requirements 
  - aws

components:                                               # mandatory, list of components
  - name: my-awshubctl-component                          # mandatory, name of the component
    source:                                               # mandatory, component source
      dir: components/s3-bucket                           # mandatory, local path where to find component

extensions:                                               
  configure:                                              # optional, steps activated during `hubctl stack configure`
    - aws
    - env

```

`hub.yaml` file has `components` field where you describe your components.

- You will also need `hub-component.yaml`, this is a reusable component, it is generic and provides an abstraction with dependencies needed for deployment.

```yaml
kind: component                                     # mandatory, defines a component manifest
version: 1                                          # mandatory, manifest schema version

requires:
  - aws
  - terraform

parameters:
  - name: bucket.name                                # parameter of the bucket name
    value: "${hub.componentName}"                    # value for the S3 bucket name parameter from hub component name. This name must be unique for S3
    env: TF_VAR_name                                 # TF_VAR_* environment variable (recommended way), mapping to environment variable for use deployment script
  - name: bucket.region                              # parameter of the bucket region 
    env: TF_VAR_region                               # Terraform environment variable for a region
    value: "eu-central-1"
  - name: aws.serviceAccount                         # parameter of the service account 
    env: TF_VAR_service_account_name                 # Terraform environment variable of the service account name 
    empty: allow

```
You can provide Terraform variables in two ways. Read more about it [here](../../../reference/components/terraform/#component-conventions)

Hubctl will automatically detect Terraform code when component contains one or more *.tf files. 
Terraform configuration with `main.rf` file:

```text
variable "name" {                                     # Create a name variable
   type = string
}

variable "service_account_name" {                     # Create a service_account_name variable
   type    = string
   default = ""
}

variable "region" {                                   # Create a region variable
   type    = string
   default = "eu-central-1"
}

provider "aws" {                                      # Configure the AWS Provider
   region  = var.region
}

terraform {
   required_version = ">= 1"

   required_providers {
      aws = {
         source  = "hashicorp/aws"
         version = "~> 4.0"
    }
  }
}

resource "aws_s3_bucket" "example" {                    # Create private Bucket With Tags
  bucket = var.name
  
  tags = {
    Name        = "Hubctl bucket"
    Environment = "Dev"
  }
}
```

The `import` file is a necessary step to allow manage resources such as AWS S3 bucket. It is a special script that to import existing resources into Terraform state.

```shell
#!/bin/sh -e
# shellcheck disable=SC2154

if gsutil -q ls -b "gs://$TF_VAR_name" > /dev/null 2>&1; then
  terraform import 'aws_storage_bucket._' "$TF_VAR_name" || true
fi

```

## Deploy Stack with Amazon S3 Component

You are now ready to run a deployment from the directory where hub.yaml is located.
The following commands are used for this:

- `hubctl stack init` - this command initializes the working directory with the `hub.yaml` file.
```shell
hubctl stack init
```

- `hubctl stack configure` - stack configuration before deployment
```shell
hubctl stack configure
```

- `hubctl stack deploy` - Runs a deployment for the entire stack, or updates the deployment of one or more components.
```shell
hubctl stack deploy
```

As a result, you could see the Amazon S3 bucket with the following command:

```shell
aws s3 ls
```

### Conclusions

In this tutorial, you create the simple Amazon S3 bucket hubctl. Use Terraform to configure this AWS component.


### See also
- [Terraform Component](../../../reference/components/terraform/) 
