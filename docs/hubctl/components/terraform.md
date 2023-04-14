# Terraform Component

### Terraform

Terraform is a one of our favorite ways how to interact with IaaS services. Hubctl will automatically detect Terraform code when component contains one or more `*.tf` files.

Parameters should be passed as Terraform variables in the form of:

* `TF_VAR_` prefixed environment variables defined in `hub-component.yaml` file
* Template for `terraform.tfvars` file

Deployment hooks can be defined via:

* `pre-deploy.sh` and `post-deploy.sh` scripts
* `pre-unploy.sh` and `post-unploy.sh` scripts
* `import.sh` a special script that to import existing resources into Terraform state.

> Note: `import.sh` maybe a necessary step to allow manage non-idempotent resources such as AWS S3 bucket. Before running terraform deployment that will fail you may want to import bucket if it already exists.

