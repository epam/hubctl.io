# Key Concepts

## Component

A component is a single service or application that makes sense to deploy on its own. It can be a database, a web server, a queue, a cache, or anything else that is a single unit of deployment.

Key characteristics of a component:
- It is a reusable unit of deployment
- It is idempotent. Which means if the component has been already deployed, it will not be deployed again however no error will be raised

Every component should support at least two operations
- `deploy` - deploy the component
- `undeploy` - reverse the deployment

Every component can be deployed with a set of parameters. Parameters are used to configure the component. For example a database component can be configured with a database name, username, password, and other parameters. A web server component can be configured with a port number, a domain name, and other parameters. Parameters let's user to abstract component configuration from the component itself.

Components can be written in any language and can be deployed with any tool. However, it is recommended to use one of the following tools:

- `terraform`
- `helm`
- `kustomize`
- `shell`
- `Makefile`
- `Azure ARM template`


## Stack

In real life a single component is not enough to run as a service. Usually it requires other components to be deployed as well. For example a web server requires a database to store data. A queue requires a database to store messages. A cache requires a database to store cached data. 

This means component can import parameters either from environment or from the other components. This is where stack comes into play. Stack is a collection of components that are deployed together. Stack defines the order of deployment and parameters that are passed to the components.

Stack can be deployed in three steps

1. [`init`](../../hubctl/cli/hubctl-stack-init) - initialize the stack, download components, hooks and other artifacts
2. [`configure`](../../hubctl/cli/hubctl-stack-configure) - configures stack requirements such as environment, access credentials, user input, etc. Anything that is required to deploy the stack
3. [`deploy`](../../hubctl/cli/hubctl-stack-deploy) - deploys the stack. You can also deploy series of individual components 

## Parameters

Parameters are used to configure components. Parameters can be passed to the component from environment or from the other components. Parameters are a simple key value pairs and defined component level and overriden by the stack or upstream components. See more details in the [parameters configuration](../manifests/component/parameters).

## Templates

Templates are used to generate configuration files for the components. Before individual component will be deployed a template will be rendered with the parameters and the result will be passed to the component. See more details in the [template configuration](../manifests/component/templates).

## Deployment Hooks

Hooks are used to execute custom logic before or after deployment of the component or a stack. Hooks are defined on the stack level. See more details in the [hooks configuration](../manifests/component).

## Toolbox

Both hubctl and components requires tools to be installed on a machine. This makes it hard to standartize the tool chain across all members of the team. Toolbox is a docker container that contains all required tools to run hubctl and components. 

See how to run toolbox by running [`hubctl toolbox`](../../hubctl/cli/hubctl-toolbox).


## DNS Bubbles

After stack has been deployed user will want to access it. The most straightforward way is to use a DNS name. To access it with DNS name. 

DNS Bubbles is a web service that can grant a temporary random DNS name. These domain names are garbage collected every 72 hours unless refreshed. This makes it useful for ephemeral environments. Environment that user will discard after they do not need it anymore. Development or test environments are perfect examples of such environments.

See more on how to configure DNS Bubbles in the [DNS Bubbles configuration](../dns).
