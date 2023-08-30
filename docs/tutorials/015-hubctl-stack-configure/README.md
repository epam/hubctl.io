# Multiple Components

This tutorial will show you how to configure hubctl with your simple component options.

## In This Tutorial

This tutorials covers the following topics:

* How to add parameters of stack and components
* How to deploy a stack with multiple components
* How to apply different configuration per component

## About

`hub.yaml` file has `components` and `parameters` fields where you describe your options.

```yaml
kind: stack                                                                   # mandatory, defines a stack manifest
version: 1                                                                    # stack manifest schema version
meta:                                                                         # optional
  name: My second deployment                                                  # optional human readable name

components:                                                                   # mandatory, list of components
  - name: my-first-component                                                  # mandatory, name of the first component
    source:                                                                   # mandatory, component source
      dir: components/hello-hubctl                                            # mandatory, local path where to find component
      git:                                                                    # optional, git source to download component from
        remote: https://github.com/epam/hubctl.io.git                         # mandatory, git repository remote url
        subDir: docs/tutorials/010-hubctl-stack-init/components/hello-hubctl  # mandatory, subdirectory in the repository
        ref: main                                                             # optional, git reference (branch, tag, commit)
  - name: my-second-component                                                 # mandatory, name of the second component
    source:                                                                   # mandatory, component source
      dir: components/hello-hubctl                                            # mandatory, local path where to find component

parameters:                                                                   # optional, stack input parameters (best practice, split to separate file or files)
  - name: message                                                             # mandatory, parameter name
    value: baz                                                                # optional, value for parameter
  - name: message                                                             # mandatory, parameter name
    component: my-first-component                                             # optional, special parameter that always bounds to component name defined in `hub.yaml`
    value: baz-first                                                          # optional, value for parameter
```

## Deploy Stack with one Component

Similar to the tutorial the [previous](../010-hubctl-stack-init) tutorial, we will deploy a stack with one component.

- Create an empty directory and change your working directory to it.

- Initialize a stack with [`hubctl stack init`](../../hubctl/cli/hubctl-stack-init/) command.

```shell
hubctl stack init -f "https://raw.githubusercontent.com/epam/hubctl.io/main/docs/tutorials/015-hubctl-stack-configure/hub.yaml"
```

Wait when stack will be initialized and component will be downloaded in the directory `components/hello-hubctl`

- Now let's update the configuration and deploy this stack with the following commands:

```bash
hubctl stack configure
```

```bash
hubctl stack deploy
```

- You can confirm stack has been deployed with command

```text
hubctl show
## ...
##   hub.stackName: My first deployment
##   message: baz-first
## status:
##   status: deployed
```
As a result, you will see the deployment components with parameters and status.
The `my-first-component` message is "base-first" because "hub.yaml" has a special message parameter for the `my-first-component` component.

## Add a New Component

- Let's open the hubfile "hub.yaml" and add following to `components` field:

```yaml
 -  name: my-second-component
    source:
        dir: components/hello-hubctl
```

- Let's update the configuration and deploy the second component. Run the following commands:

```bash
hubctl stack configure
```

```shell
hubctl stack deploy
```

As a result, you will see the deployment components `my-first-component` and `my-second-component`.
```text
## --- File: deploy.sh
# Component my-first-component is saying: baz-first
# Component my-first-component deployed successfully!

# Component my-second-component is saying: baz
# Component my-second-component deployed successfully!
```

- Let's create a special parameter for the `my-second-component` component. To do this, add the following to the `parameters` field of the hub file "hub.yaml":

```yaml
 -  name: message
    component: my-second-component
    value: baz-second
```

- Update the configuration and deployment:

```bash
hubctl stack configure
```

```shell
hubctl stack deploy
```

As you can see, the `message` parameter has changed for the `my-second-component` component
```text
## --- File: deploy.sh
# Component my-second-component is saying: baz-second
# Component my-second-component deployed successfully!
```

- Inspect parameters for both components.
Run the following commands:
```shell
hubctl show -c "my-first-component"
```

```shell
hubctl show -c "my-second-component"
```

- Now let's undeploy the second component and run the echo command.
To start undeploying for one or more components (provided as a comma-separated value), run the following command.

```shell
hubctl stack undeploy -c "my-second-component"
```

Read more about undeploy [here](../../hubctl/cli/hubctl-stack-undeploy/)

- Observe the result

```shell
hubctl show
## ...
# status: incomplete
```

After we undeploy a second component, the stack status is changed from `deployed` to `incomplete`. This means one or more components are not deployed.

> Note: on the contrary, status `deployed` means all components of a stack are deployed.

### Conclusions

In this tutorial, we added our own parameters and deployed a new configuration. We made sure that the new component was deployed and the next step was to undeploy this component.

## What's Next?

Next, we will create a component from scratch, digging into hubctl and its additional features.
Go to the [next tutorial](../020-shell-component/)
