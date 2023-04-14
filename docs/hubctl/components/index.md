# Components

Component is a piece of software that can be _deployed_ and _undeployed_ that actually makes sense. Components could be anything - hubctl is not tied to any particular automation technology the only requirements are:

- Automation code that hubctl knows how to deploy. This can be as simple as shell script or more advanced such as ARM template or Terraform.
- `hub-component.yaml` that describes component requirements, input and output parameters. Parameters can be passed to the automation code via environment variables or via templates.

Optionally component could have:

- `Template` - probably  way how to inject parameters from `hub-componet.yaml` to automation. Hubctl supports both string replacement and go-templates. 
- `pre-deploy` and `post-deploy` hooks - scripts that will be executed before and after component deployment.

## Automation Code

By design hubctl is not tied to any particular automation technology. However we have got prebuilt support for most popular automation tools

### Shell Script

Most flexible way and the most simple one. You only need to define a two scripts and pass parameters via environment variables.

* `deploy.sh` - script that will be executed during component deployment
* `undeploy.sh` - script that will reverse deployment. Every component should have undeploy script.

Configuration can be passwd via environment variables defined in `hub-component.yaml` file. Hubctl will not pass any arguments to the scripts

## Helm

Helm is a package manager for Kubernetes. Hubctl will automatically detect Helm charts when component contains a `values.yaml` file.
