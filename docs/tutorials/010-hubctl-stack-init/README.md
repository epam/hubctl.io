# First Deployment

This tutorial will show you how hubctl works with a simple example.
We will simply initialize and deploy hubctl with one pre-configured component.

## About

At the first, let's understand what is the minimum configuration for hubctl.

- A specific configuration defining a stack manifest in `hub.yaml` is the first thing needed. Such a file describes the components and options for deployment.

```yaml
kind: stack
version: 1
meta:
  name: My first deployment

components:
  - name: hello-hubctl
    source:
      dir: components/hello-hubctl
      git:
        remote: https://github.com/epam/hubctl.io.git
        subDir: docs/tutorials/010-hubctl-stack-init/components/hello-hubctl
        ref: main

parameters:
  - name: hello-hubctl
    parameters:
      - name: message
        value: foo

```

  `hub.yaml` file has `components` and `parameters` fields where you describe your options.

- You will also need `hub-component.yaml`, this is a reusable component, it is generic and provides an abstraction with dependencies needed for deployment.

```yaml
kind: component
version: 1

parameters:
  - name: hello-hubctl
    parameters:
      - name: message
        value: bar

```

  `hub-component.yaml` contains the `parameters` field for your configuration.

[Parameters](../../../reference/manifests/stack/parameters/) are used to configure stack and components in both stack manifest `hub.yaml` and component manifest `hub-component.yaml`.

If you are deploying using shell scripts, you need to create the expected scripts in the component folder: `deploy.sh` and `undeploy.sh`. Make sure they're executable `chmod +x deploy.sh`.
Read more details [here](../../../reference/components/shell/).

```shell
#!/bin/sh -e

echo "Component $HUB_COMPONENT is saying: $MESSAGE"
echo "Component $HUB_COMPONENT deployed successfully!"
```

```shell
#!/bin/sh -e

echo "Component $HUB_COMPONENT undeployed successfully!"
```

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
hubctl stack init -f "https://github.com/epam/hubctl.io/tree/main/docs/tutorials/010-hubctl-stack-init/hub.yaml"
```

Read more about `hubctl stack init` [here](../../../hubctl/cli/hubctl-stack-init/)

### Deployment

The next step is to run the deployment using the following command:

```shell
hubctl stack deploy
```

Read more about the command `hubctl stack deploy` [here](../../../hubctl/cli/hubctl-stack-deploy/)

If you did everything correctly, the deployment worked without errors, then the command returns the name of the component that was deployed.

```text
--- File: deploy.sh
Component hello-hubctl is saying: foo
Component hello-hubctl deployed successfully!
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
--- File: undeploy.sh
Component hello-hubctl undeployed successfully!
```

## Conclusions

Using a simple example with a ready-made configuration for the `hub.yaml` and `hub-component.yaml` files, you learned what the minimum configuration for hubctl consists of, as well as how hubctl can be used. Go ahead.

## What's Next?

You can change the hubctl config and deploy it with your parameters. Next, you will look at how to do this.
Go to the [next tutorial](../../../tutorials/015-hubctl-stack-configure/)
