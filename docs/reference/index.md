# Hubfile

[Hubfiles](./manifests) defines a stack, parameters and components. Each component has it's own manifest. 

* Stack manifest file `hub.yaml` and optional `param.yaml` defined on the top level. 
* Components are defined in the `components` directory. Each have a hubfile `hub-component.yaml` that defines the structure of the component and rules how to deploy it. 

## Directory Structure

While directory structure has not been fixed. yet we recommend the following:

```text
├── bin
│   └── deployment-hook.sh       
├── components
│   ├── component1
│   │   ├── hub-component.yaml
│   │   ├── deploy.sh
│   │   └── undeploy.sh
│   └── component2
│       ├── hub-component.yaml
│       └── main.tf
├── hub.yaml
└── params.yaml
```

In this example the`component1` uses [shell](../components/shell) to deploy. It `deploy.sh` and `undeploy.sh`. 

The `component2` is using [Terraform](../components/terraform), and contains `*.tf` file (or files)

Hubfile `hub.yaml` can define a deployment hooks, something that needs to be executed before or after individual component deployment. This webhook has been placed in the `bin` directory.

## See Also

* [Hubfiles](./manifests)
* [Hubctl Components](./components)
