# Quick start

This tutorial will show you how hubctl works with a simple example. 
We will simply initialize and deploy hubctl with one pre-configured component.

##About
At the first, let's understand what is the minimum configuration for hubctl.

- A specific configuration defining a `hub.yaml` or `parameters.yaml` file at the stack level is the first thing needed. Such a file describes the components and options for deployment.

- You will also need `hub-component.yaml`, this is a reusable component, it is generic and provides an abstraction with dependencies needed for deployment.

Now let's take a look at these files and see what each should consist of at least:

```hub.yaml 
kind: stack
version: 1
meta:
  name: My first deployment
components:
- name: hello-hubctl-component
  source:
    dir: components/hello-hubctl
     git:
      remote: https://github.com/epam/hubctl.io/tree/main/docs/tutorials/010-hello-hubctl/components/hello-hubctl
      ref: main
      subDir: hello-hubctl
parameters:
- name: message
  value: hello-my-first-hubctl
```
 "hub.yaml" file has `components` and  `parameters` fields where you describe your options.
 
 
```hub-component.yaml 
kind: component
version: 1
parameters:
- name: hub.componentName
  env: HUB_COMPONENT_NAME
- name: message
  value: foo
  env: MESSAGE
```
"hub-component.yaml" contains the `parameters` field for your configuration.


So, if we have a ready-made configuration with customized components, how can we launch them? The following commands are used for this:

- `hubctl stack init [options]` - this command initializes the working directory containing the hub file (hub.yaml).
- `hubctl stack configure` - stack configuration before deployment
- `hubctl stack deploy` - Runs a deployment for the entire stack, or updates the deployment of one or more components.


### Initialization

Now let's try to run simple example with a ready-made configuration that contains one component.

Before you start you need initialize hubctl. 
Download the minimal component from github https://github.com/epam/hubctl.io/tree/main/docs/tutorials/010-hello-hubctl to a your local directory and run the following command:

```shell
hubctl stack init -f "hub.yaml" 
```
or without download folders you can initialize the following command

```shell
hubctl stack init -f "https://github.com/epam/hubctl.io/tree/main/docs/tutorials/010-hello-hubctl/hub.yaml" 
```

Read more about `hubctl stack init` [here](/hubctl/cli/hubctl-stack-init/)

### Deployment

The next step is to run the deployment using the following command:

```shell
echo "Component $HUB_COMPONENT_NAME deployed successfully!"
# Component hello-hubctl-component deployed successfully!
```
This command returns the name of the component that was deployed.

```shell
echo "Component $HUB_COMPONENT_NAME is saying: $MESSAGE"
# Component hello-hubctl-component is saying: hello-my-first-hubctl
```
This command returns the name of the component and the parameter with the value of the message.

Read more about the command `hubctl stack deploy` [here](/hubctl/cli/hubctl-stack-deploy/)

### Conclusions

Using a simple example with a ready-made configuration for the "hub.yaml" and "hub-component.yaml" files, we learned what the minimum configuration for hubctl consists of, as well as how hubctl can be run. Go ahead.

## What's Next?

You can change the hubctl config and deploy it with your parameters. Next, we will look at how to do this.
Go to the [next tutorial](/tutorials/015-hello-kubectl-configure/)

