# Hubfile

Hubfile is a YAML file that describes a stack or component. It is a source of truth for hubctl deployment. There are two types of Hubfiles:

* Component manifest: `hub-component.yaml`
* Stack manifest: `hub.yaml`, `params.yaml`

## [Component Manifest](./manifests/component)

Component manifest describes how to deploy a component:

* Requirements, that the component expects from environment or another (upstream) component
* What are the component input and output parameters
* Additional verbs (besides `deploy` and `undeploy`) that can be executed on the component
* Describes templates used by the component

## [Stack manifest](./manifests/stack/)

Stack manifest describes how one or multiple components are deployed together:

* Requirements from environment
* Defines components list and dependencies between them
* Defines stack input and output parameters
* Defines deployment hooks


### Directory Hierarchy

Here is the typical directory hierarchy for a stack:

```text
├── bin
│   └── deployment-hook.sh       
├── components
│   ├── component1
│   │   ├── hub-component.yaml
│   │   ├── deploy.sh
│   │   └── undeploy.sh
│   └── component2
│       ├── hub-component.yaml
│       └── main.tf
├── hub.yaml
└── params.yaml
```

Above you can see a stack manifest files: `hub.yaml` and `params.yaml`. Also, there are two components: `component1` and `component2`. Both components have a component manifest files `hub-component.yaml`. 

We can see that the `component1` has `deploy.sh` and `undeploy.sh` scripts that are used by `hubctl` to deploy and undeploy the component. 

THe `component2` has `main.tf` which means `hubctl` will use Terraform to deploy `component2`.

## Deployment Hooks

Sometimes before or after a component deployment, SREs need to perform an action that extends the component and often is environment or context-specific. To achieve that component lifecycle hooks were introduced. This approach allows keeping components KISS and if-less. Please refer to the example below:

```yaml
components:
- name: external-dns
  source:
    dir: components/external-dns
    git:
      remote: 'https://github.com/agilestacks/components.git'
      ref: master
      subDir: external-dns
  hooks:
  - file: bin/pre-deploy-hook
    error: ignore
    triggers:
    - pre-deploy
  - file: bin/post-deploy-hook
    triggers:
    - post-deploy
```

There are 2 hooks in the example:

- File `pre-deploy-hook` from the `.hub` directory relative to the directory where the Hub manifest file is located (`hub.yaml`) will be executed BEFORE `external-dns` component is deployed. `error: ignore` means that stack deployment will continue even if there is an error in the hook (it exits with non 0 exit code)
- File `post-deploy-hook` from the `.hub` directory relative to the directory where the Hub manifest file is located (`hub.yaml`) will be executed AFTER `external-dns` component is deployed.

> Note: `triggers` array also supports regular expressions, such as `*-deploy` or `post-*`

Hooks will be executed in the order they are defined in the manifest file.

### Parameters file

Stack parameters should be placed in `params.yaml` file - separately from `hub.yaml`. It is possible to merge them though. There could be any number of parameters files.

> Note: this is a good practice to split parameters from `hub.yaml` into it's own file `params.yaml` or even a series of `params.yaml` files. The parameter files can be referenced in `hub.yaml` as the following

```yaml
extension:
  inclue:
  - params.yaml
```

## See Also

* [Hubfiles](./manifests)
