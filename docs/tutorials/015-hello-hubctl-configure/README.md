# Quick configure

This tutorial will show you how to configure hubctl with your simple component options. 

##About

You can change the configuration in "hub.yaml" and deploy with your options. 
Hubctl reads configuration information from one or more of the mentioned [hubfiles](/reference/) and applies it before deploying the stack. It is also possible to define the order of the various scenarios in the hub file using requirements via input parameters.

### Configuration

1) Initialize and deploy the hubctl from  https://github.com/epam/hubctl.io/tree/main/docs/tutorials/010-hello-hubctl as [the previous tutorial](/tutorials/010-hello-hubctl/)

2) Open the hubfile (hub.yaml) and add following:
 to `components` field: 
```hub.yaml 
 
- name: my-second-component
  source:
    dir: components/hello-hubctl

```  

to `parameters` field: 
```hub.yaml 
 
- name: message
  component: my-second-component
  value: baz

```  
3) Run deployment with added components
```shell
echo "Component $HUB_COMPONENT_NAME deployed successfully!"
echo "Component $HUB_COMPONENT_NAME is saying: $MESSAGE"

# Component my-first-component is saying: bar
# Component my-first-component deployed successfully!
# Component my-second-component is saying: baz
# Component my-second-component deployed successfully!

```
4) Now let's undeploy the second component and run the echo command.
To start undeploying for one or more components (provided as a comma-separated value), run the following command.
```shell
hubctl stack undeploy -c "my-second-component"

```
Read more abour undeploy [here](/hubctl/cli/hubctl-stack-undeploy/)

5) Run the deployment and check the components of the deployment.

```shell
echo "Component $HUB_COMPONENT_NAME deployed successfully!"
echo "Component $HUB_COMPONENT_NAME is saying: $MESSAGE"

# Component my-first-component is saying: bar
# Component my-first-component deployed successfully!

```

### Conclusions

In this tutorial, we added our own parameters and deployed a new configuration. We made sure that the new component was deployed and the next step was to undeploy this component. 

## What's Next?

Next, we will create a component from scratch, digging into hubctl and its additional features.
Go to the [next tutorial](/tutorials/020-shell-component/)