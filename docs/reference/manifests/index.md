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

### Split Parameters into Separate Files

This considered as a good practice for Stack Manifests.

Parameter definitions for entire stack can be quite large. For convenience parameters of the stack into the `params.yaml` or in the group of `params-*.yaml` files. Then you can refer additional files in the `hub.yaml` as the following:

```yaml
extension:
  include:
  - params.yaml
```

See more in [hubctl extensions](./stack/extensions)

> Note: this is a good practice to split parameters from `hub.yaml` into it's own file `params.yaml` or even a series of `params.yaml` files. The parameter files can be referenced in `hub.yaml` as the following

## See Also

* [Component manifest](./component)
* [Stack manifest](./stack)
