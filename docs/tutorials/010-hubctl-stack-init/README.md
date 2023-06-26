# First Deployment

This tutorial will show you how hubctl works with a simple example.
We will simply initialize and deploy hubctl with one pre-configured component.

## About

At the first, let's understand what is the minimum configuration for hubctl.

```text

├── components                           # Directory with components
│    └── hello-hubctl                    # Directory with configurations
│        ├── hub-component.yaml          # Component manifest
│        ├── deploy.sh                   # Shell script to deploy the component
│        └── undeploy.sh                 # Shell script to undeploy the component
└── hub.yaml                             # Stack manifest
```
- A specific configuration defining a stack manifest in `hub.yaml` is the first thing needed. Such a file describes the components and options for deployment.

```yaml
kind: stack                                                                   # mandatory, defines a stack manifest
version: 1                                                                    # stack manifest schema version
meta:                                                                         # optional
  name: My first deployment                                                   # optional human readable name

components:                                                                   # mandatory, list of components
  - name: hello-hubctl                                                        # mandatory, name of the component
    source:                                                                   # mandatory, component source
      dir: components/hello-hubctl                                            # mandatory, local path where to find component
      git:                                                                    # optional, git source to download component from
        remote: https://github.com/epam/hubctl.io.git                         # mandatory, git repository remote url
        subDir: docs/tutorials/010-hubctl-stack-init/components/hello-hubctl  # mandatory, subdirectory in the repository
        ref: main                                                             # optional, git reference (branch, tag, commit)

```

`hub.yaml` file has `components` field where you describe your components.

- You will also need `hub-component.yaml`, this is a reusable component, it is generic and provides an abstraction with dependencies needed for deployment.

```yaml
kind: component                                     # mandatory, defines a component manifest
version: 1                                          # mandatory, manifest schema version

parameters:                                         
  - name: message                                   # mandatory, parameter name
    value: foo                                      # optional, value for parameter 
    env: MESSAGE                                    # optional, mapping to environment variable for use deployment script

```

  `hub-component.yaml` contains the `parameters` field for your configuration.

[Parameters](../../../reference/manifests/stack/parameters/) are used to configure stack and components in both stack manifest `hub.yaml` and component manifest `hub-component.yaml`.

If you are deploying using shell scripts, you need to create the expected scripts in the component folder: 
`deploy.sh` 

```shell
#!/bin/sh -e

echo "Component $HUB_COMPONENT is saying: $MESSAGE"
echo "Component $HUB_COMPONENT deployed successfully!"
```

and `undeploy.sh`

```shell
#!/bin/sh -e

echo "Component $HUB_COMPONENT undeployed successfully!"
```

Make sure the `deploy.sh`, `undeploy.sh` are executable `chmod +x deploy.sh`, `chmod +x undeploy.sh`.
Read more details [here](../../../reference/components/shell/).

So, if you have a ready-made configuration with customized components, how can you launch them?
The following commands are used for this:

- `hubctl stack init` - this command initializes the working directory with the `hub.yaml` file.
- `hubctl stack configure` - stack configuration before deployment
- `hubctl stack deploy` - Runs a deployment for the entire stack, or updates the deployment of one or more components.

### Initialization

Now let's try to run simple example with a ready-made configuration that contains one component.

Before you start you need initialize your stack.
Download the minimal component from [github](https://github.com/epam/hubctl.io/tree/main/docs/tutorials/010-hubctl-stack-init) to a your local directory and run the following command:

```shell
hubctl stack init
```

or without download folders you can initialize the following command

```shell
hubctl stack init -f "https://raw.github.com/epam/hubctl.io/tree/main/docs/tutorials/010-hubctl-stack-init/hub.yaml"
```

Read more about `hubctl stack init` [here](../../../hubctl/cli/hubctl-stack-init/)

### Update configuration

This step is to update your configuration with the following command:

```shell
hubctl stack configure
```

### Deployment

The next step is to run the deployment using the following command:

```shell
hubctl stack deploy
```

Read more about the command `hubctl stack deploy` [here](../../../hubctl/cli/hubctl-stack-deploy/)

If you did everything correctly, the deployment worked without errors, then the command returns the name of the component that was deployed.

```text
## --- File: deploy.sh
# Component hello-hubctl is saying: foo
# Component hello-hubctl deployed successfully!
```

This command returns the name of the component `hello-hubctl` and the parameter with the value of the message `foo`.

### Undeploy

You can also run undeploy with the following command:

```shell
hubctl stack undeploy
```

Read more about the command `hubctl stack undeploy` [here](../../../hubctl/cli/hubctl-stack-undeploy/)

The command returns the name of the component `hello-hubctl` that was undeploy.

```text
## --- File: undeploy.sh
# Component hello-hubctl undeployed successfully!
```

## Conclusions

Using a simple example with a ready-made configuration for the `hub.yaml` and `hub-component.yaml` files, you learned what the minimum configuration for hubctl consists of, as well as how hubctl can be used. Go ahead.

## What's Next?

You can change the hubctl config and deploy it with your parameters. Next, you will look at how to do this.
Go to the [next tutorial](../../../tutorials/015-hubctl-stack-configure/)
