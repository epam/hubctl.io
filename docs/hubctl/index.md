# Overview

[Hubctl](https://github.com/epam/hubctl) is stack composition and lifecycle tool:

* template and stack creation, stack deploy / undeploy / backup lifecycle;
* stack and component parameters, output variables, and state;

## Components

Hubctl core experience is about connecting various pieces of software - called components into a stack, each component developed independently yet designed to work together, via common set of parameters for inputs and outputs. See more about components [here](components)

## Stacks

In real life we rarely deploy just a single component. We usually need to take several components and _stack_ them together into a coherent deployment unit that actually makes sense to deploy

To deploy a stack hubctl needs a `hub.yaml` file that lists the components and parameters that are needed to deploy the stack.
