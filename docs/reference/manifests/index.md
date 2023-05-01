# Hubfile

Sometimes called as hub manifest. is a YAML file that describes a stack or a component. It is a source of truth for hubctl deployment. We will use both names interchangeably.

There are two types of manifests:

## [Component manifest](./component)

__Defined as__ `hub-component.yaml`

Located in the component directory. This file has the following structure:

* Requirements, that the component expects from environment or another (upstream) component
* What are the component input and output parameters
* Additional verbs (besides `deploy` and `undeploy`) that can be executed on the component
* Describes templates used by the component

See more about component manifest in [here](./component).

## [Stack manifest](./stack)

__Defined as__: `hub.yaml`, `params.yaml`, `params-*.yaml`. 

Stack manifest describes how one or multiple components are deployed together. It has the following structure:

* Requirements from environment
* Defines components list and dependencies between them
* Defines stack input and output parameters
* Defines deployment hooks

See more about stack manifest in [here](./stack).

## See Also

* [Component manifest](./component)
* [Stack manifest](./stack)
