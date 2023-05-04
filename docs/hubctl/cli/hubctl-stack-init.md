# Command: `hubctl stack init`

This command initializes working directory containing a hubfile (`hub.yaml`). This is the first command that you should run when you start working with a new stack.

## Usage 

Depending on your needs there are few ways to initialize a stack in the current directory:

`hubctl stack init [options]`

This command will perform different initialization steps in order to prepare you current working directory for deployment

### Download Hubfiles

Activated when flag: `-f URL` supplied. 

Hubctl will download a hubfile referenced with `-f` flag and save it to the current directory. Then it will download any other parameters file referenced in the hubfile and save it to the current directory. 

```yaml
# hub.yaml
extensions:
  include:
  - params.yaml
```

Example above shows a `parameter.yaml` referenced in hubfile. It will be downloaded and saved to the current directory. URL of this file will be interpreted as relative to the URL of the hubfile.

If you have multiple hubfiles but you don't want to keep a direct reference in `hub.yaml` (when you have parameter files per environment, or your environments have different components). Then use flag `-f <hubfile or URL>` multiple times

### Download Configuration Scripts

In a similar way hubctl will download a deployment hooks referenced in the hubfile

```yaml
extensions:
  init:
  - bin/my-init-script.sh
  configure:
  - bin/my-configure-script.sh
  deploy:
    before:
    - bin/my-before-deploy-script.sh
    after:
    - bin/my-after-deploy-script.sh
  undeploy:
    before:
    - bin/my-before-undeploy-script.sh
    after:
    - bin/my-cleanup-script.sh
```

1. Download init scripts referenced in the hubfile
2. Download configure scripts referenced in the hubfile
3. Download before and after deploy (undeploy)

### Download Deployment Hooks

```yaml
components:
- name: external-dns
  source:
    dir: components/external-dns
  hooks:
  - file: bin/do-something
    triggers:
    - pre-deploy
    - post-undeploy
```

When hubfile refers component deployment hooks, hubctl will download them and save to the current directory

### Download Component Sources

Next steps hubctl will download components if directory referenced in the hubfile does not exist. 

```yaml
components:
- name: external-dns
  source:
    dir: components/external-dns
    git:
      remote: https://github.com/epam/hub-kubeflow-components.git
      ref: develop
      subDir: external-dns
```

For more details see [Components Reference](../../../reference/manifests/stack/components).


## Initialize from Remote State

There is an option to initialize stack from remote state. This is useful when you do not have state locally or it has been deployed by someone else. 

Run the command:

```bash
hubctl stack init "<remote-state-url>"
```

This command will download remote state and initialize `.env` variables from parameters listed in the state. Then you should be able to interact with the stack or it's components as usual.

## Stack Name and Domain Names

When you initialize a stack, hubctl will generate a random stack name unless hubfile contains exact value of stack name. When stack is using a publicly available domain name, then hubctl will use it as a stack name. 

See on how to autogenerate domain names here: [Domain Names](../../../reference/design/dns)

## Command Parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-f --file <hubfile>` | path (or URL) to hubfile with stack definitions. This argument can repeat multiple times | x |
| `-s --state <statefile>` | Path or URL to |
| `--force` | Specify this fag if current stack has been already initialized. This flag will overwrite existing configuration |

## Common Parameters

These parameters applies across all extension commands

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-V --verbose` | extra verbosity for diagnostics | |
| `-h --help` | print help and usage message | |

## Usage Example

Example on how to initialize a new stack to deploy a GKE cluster

```bash
hubctl stack init -f "https://hubctl.io/tutorials/020-shell-component/hub.yaml"
```

## See also

* [`hubctl stack configure`](../hubctl-stack-configure)
* [`hubctl stack`](../../stack)
* [Domain Names](../../../reference/design/dns)
