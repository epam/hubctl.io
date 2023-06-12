# Multiple Components

This tutorial will show you how to configure hubctl with your simple component options. 

## In This Tutorial

This tutorials covers the following topics:

* How to deploy a stack with multiple components
* How to apply different configuration per component


## Deploy Stack with one Component

Similar to the tutorial the [previous](../../../tutorials/010-hello-hubctl/) tutorial, we will deploy a stack with one component.

1) Create an empty directory and change your working directory to it.

2) Initialize a stack with [`hubctl stack init`](../../../hubctl/cli/hubctl-stack-init/) command.
```shell
hubctl stack init -f "https://hutctl.io/tutorials/015-hubctl-stack-configure/hub.yaml"
```
Wait when stack will be initialized and component will be downloaded in the directory `components/hello-hubctl`

3) Now let's deploy this stack with the following command:
```bash
hubctl stack deploy
```
4) You can confirm stack has been deployed with command 
```shell
hubctl show 
## ...
## status;
##   status: deployed
```
As a result, you will see the deployment components with parameters and status.

## Add a New Component

5) Let's open the hubfile "hub.yaml" and add following to `components` field: 
```hub.yaml 
 - name: my-second-component
  source:
    dir: components/hello-hubctl
```  

and add following to `parameters` field of the hubfile "hub.yaml": 
```hub.yaml 
 - name: message
  component: my-second-component
  value: baz
```  

6) Repeat deployment command

```shell
hubctl stack deploy

```
As a result, you will see the deployment components `my-first-component` and `my-second-component`.
```results
#--- File: deploy.sh
#Component my-first-component is saying: foo
#Component my-first-component deployed successfully!

#Component my-second-component is saying: baz
#Component my-second-component deployed successfully!
```

7) Inspect parameters for both components

```shell
hubctl show -c "my-first-component"
```

```shell
hubctl show -c "my-second-component"
```

8) Now let's undeploy the second component and run the echo command.
To start undeploying for one or more components (provided as a comma-separated value), run the following command.
```shell
hubctl stack undeploy -c "my-second-component"
```
Read more about undeploy [here](../../../hubctl/cli/hubctl-stack-undeploy/)

9) Observe the result

```shell
hubctl show 
# status: incomplete
```

After we undeploy a second component, the stack status is changed from `deployed` to `incomplete`. This means one or more components are not deployed.

> Note: on the contrary, status `deployed` means all components of a stack are deployed.

### Conclusions

In this tutorial, we added our own parameters and deployed a new configuration. We made sure that the new component was deployed and the next step was to undeploy this component. 

## What's Next?

Next, we will create a component from scratch, digging into hubctl and its additional features.
Go to the [next tutorial](../../../tutorials/020-shell-component/)
