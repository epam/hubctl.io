# Hubfile

Hubfile is a YAML file that describes a stack or component. It is a source of truth for hubctl deployment. There are two types of Hubfiles:

* Component manifest: `hub-component.yaml`
* Stack manifest: `hub.yaml`, `params.yaml`

## Component Manifest

Component manifest describes how to deploy a component:

* Requirements, that the component expects from environment or another (upstream) component
* What are the component input and output parameters
* Additional verbs (besides `deploy` and `undeploy`) that can be executed on the component
* Describes templates used by the component

## Stack manifest

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

> Note: this is a good practice to split parameters from `hub.yaml` into it's own file `params.yaml` or even a series of `params.yaml` files. The parameter files can be referenced in `hub.yaml` as the following

```yaml
extension:
  inclue:
  - params.yaml
```

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

## Outputs

When more than a single instance of the same component is deployed in the stack - think two PostgreSQL databases, then there is an ambiguity because both components provides same outputs, ie. `endpoint` and `password`.

To bind input parameters of the `pgweb` to specific PostgreSQL, use `depends`:

```yaml
components:
- name: pg1:
  source: components/postgresql
- name: pg2:
  source: components/postgresql
- name: pgweb1:
  source: components/pgweb
  depends:
  - pg1
```

The outputs of `depends` are searched in turn, then the _global_ outputs pool.

## Inputs

To set parameters for a specific component instance use `component`:

```yaml
parameters:
- name: component.postgresql
  component: pg1
  parameters:
```

The component `<name>` first looks for parameters that are qualified with `component: <name>`, then _global_ parameters space.

## Manifest composition

`hub.yaml.elaborate` manifest is composed by joining `hub.yaml` and `hub-component.yaml` files with [YAML] delimiter literal `---\n`. Thus the first document in the `hub.yaml.elaborate` is special.

## Requirements

Both stack and component may describe dependencies that must be satisfied - _requires_, before (fully parameterized) stack could be deployed. Some examples of requirements:

- Cloud kind: AWS, Azure, GCP;
- Kubernetes
- What other types of components (_provides_) must be already deployed in the environment or will be deployed with the stack.

This is a high-level check which is possible to perform by checking the environment and tools or short-circuiting in-stack requirements to _provides_.

For example:

```yaml
requires:
- aws
- kubernetes
- postgresql
```

## Provides

Stack and components declares _provides_ - a capability that is added to the stack and provided by it after deployment.

```yaml
provides:
- kubernetes
- tls-ingress
```

The requires and provides are arbitrary literals. It could be the name of a product installed or generic capability e.g. `ingress`.

## Components

Components are building blocks of a stack. There could be multiple instances of the same component in the stack:

```yaml
components:
- name: backend-ecr
  source:
    dir: components/ecr
    git:
      remote: 'https://github.com/agilestacks/components.git'
      ref: master
      subDir: ecr
- name: frontend-ecr
  source:
    dir: components/ecr
```

## Parameters

Parameters declarations form a tree-like structure where leafs have values and nodes should have nested parameters:

```yaml
parameters:
- name: cloud
  brief: Cloud Parameters
  kind: user
  description: ...
  parameters:
  - name: kind
    value: aws                 # set to value provided by user
    default: gcp               # use default, if not provided
  - name: account
    fromEnv: CLOUD_ACCOUNT
  - name: regions
    value: [us-east-1, us-east-2]
- name: component
  parameters: [{name: kubernetes.worker.size, value: m5.large,}]
- name: deployment
  value: standalone
```

Native YAML syntax could be used to short-circuit nested declarations. The above is effectively flattened into list of parameters:

```text
cloud.kind
cloud.account
cloud.regions
component.kubernetes.worker.size
deployment
```

The values are in most cases plain text / scalar type, yet we support arrays and maps - datatypes native to JSON and YAML.

### Parameter kind

There are high-level user-provided parameters - the facts user do care about: which cloud and cloud account to use, what region to deploy to, etc.

There are also lower-level technical parameters, which Hub CLI must derive from other places, such as backend service endpoint which may come from another stack or from component output.

### Parameters file

Stack parameters should be placed in `params.yaml` file - separately from `hub.yaml`. It is possible to merge them though. There could be any number of parameters files.

### Parameter from environment variable

Parameters that are environment specific and managed with [`.envrc`](https://direnv.net) or [`.env`](https://pypi.org/project/python-dotenv/) could be captured from OS environment by `fromEnv: AWS_REGION`.

### Parameter from file

Parameter value could be read from file `fromFile: config/stage/password`.

## Outputs

Outputs are scalar or structured values produced by component or stack.

```yaml
outputs:
- cloud.avalabilityZones
- dns.domain
  value: ${dns.name}.${dns.baseDomain}
```

### Securing outputs

Output could be a secret that should not be leaked to deployment log. Such outputs could be captured with `hub util otp` one-time pad or read from a file.

## Lifecycle

Every part of the stack has a lifecycle is optional and can be omitted.

Standard verbs are: deploy, undeploy. Additional verbs could be: backup, connect, etc. Verbs are delegated to implementations in the component source code. There is additional support for Terraform, Make, and Helm see [more](/hubctl/components)

```yaml
lifecycle:
  verbs:
  - deploy
  - undeploy
  order:
  - postgresql
  - api
  - nginx-api
  - nginx-frontend
  readyCondition:
    dns: ${dns.domain}
    url: https://${dns.domain}/api/v1/
    waitSeconds: 600
```

`readyCondition` specifies additional checks that must complete successfully within `waitSeconds` duration for stack deployment to succeed.

> Note: if you omit verbs. then It assumes stack limited to [deploy, undeploy] verbs

## See Also

* [Hub CLI](/hubctl)
* [Hub Components](/hubctl/components)
