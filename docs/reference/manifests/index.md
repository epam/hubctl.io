# Hubfile

Sometimes called as hub manifest. is a YAML file that describes a stack or a component. It is a source of truth for hubctl deployment. We will use both names interchangeably.

There are two types of manifests:

* Component manifest: `hub-component.yaml`
* Stack manifest: `hub.yaml`, `params.yaml`

## [Component manifest](./component)

Component manifest describes how to deploy a component:

* Component `requires` (that the component expects from environment or another (upstream) component)
* Component `provides` what capability component will add to the stack (e.g. `kubernetes` or `bucket`)
* Component input `parameters`:
  - names, defines interface for the component
  - defaults 
  - mapping to OS environment variables (to the deployment scripts)
* Component `outputs` (to be used as inputs by downstream components)
* Component `lifecycle`
  - verbs (besides `deploy` and `undeploy`) that can be executed on the component
  - readiness probes
* Describes `templates` used by the component

See more about component manifest in [here](component.md).

## [Stack manifest](./stack)

Stack manifest describes how one or multiple components are deployed together:

* Stack `requires` from environment
* Describes `components` list and dependencies between them
* Describes stack input `parameters`
  - names
  - values,
  - Mapping from OS environment variables and default values
* Describes deployment `hooks`

## See Also

* [Component manifest](./component)
* [Stack manifest](./stack)
