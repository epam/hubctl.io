# Section `components`

```yaml
components:
- name: external-dns
  source:
    dir: components/external-dns
    git:
      remote: https://github.com/epam/hub-kubeflow-components.git
      ref: main
      subDir: external-dns
  depends:
  - cert-manager
```

Above you can see `external-dns` component sources are under `./components/external-dns/` directory.

Section `components.source.git` section is optional. If not specified then `hubctl stack init` will not pull the component from git repository if this component does not exist. This operation happens during `hubctl stack init`

Section `components.depends` defines dependency between components. This takes effect on the:

- Components deployment run-list `hubctl` will schedule component deployment in the order of dependency and then in order of declaration. User can overwrite order by declaring section `lifecycle.order` in stack manifest.
- Parameters resolution. Let's say there are two components who output the same parameter. Section `depends` will tell to `hubctl` which component parameters must be taken as input.

## Component lifecycle hooks

Sometimes before or after a component deployment, SREs need to perform an action that extends the component and often is environment or context-specific. To achieve that component lifecycle hooks were introduced. This approach allows keeping components KISS and if-less. Please refer to the example below:

```yaml
components:
- name: external-dns
  hooks:
  - file: bin/do-something              # relative to the directory where the hugctl manifest file is located (`hub.yaml`)
    brief: Some description of my hook  # optional, brief description for hook
    error: ignore                       # optional, default is `error: fail`
    triggers:                           # optional, default is `triggers: [pre-deploy, post-deploy]`
    - pre-deploy
    - post-undeploy
  source:
    dir: components/external-dns
```

There are 2 hooks in the example:

* File `pre-deploy-hook` from the `.hub` directory relative to the directory where the Hub manifest file is located (`hub.yaml`) will be executed BEFORE `external-dns` component is deployed. `error: ignore` means that stack deployment will continue even if there is an error in the hook (it exits with non 0 exit code)
* File `post-deploy-hook` from the `.hub` directory relative to the directory where the Hub manifest file is located (`hub.yaml`) will be executed AFTER `external-dns` component is deployed.

Additionally,

* `triggers` array also supports regular expressions, such as `*-deploy` or `post-*`
* All hooks matching the expression will be executed, and hook order from the `hooks` list will be maintained.
