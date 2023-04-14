# Command: `hubctl stack undeploy`

Reverse deployment operation for entire stack or particular components

Because `undeploy` is a reverse operation to `deploy`, you might want to check out article for [`hubctl stack deploy`](../hubctl-stack-deploy.) sections about __executors__ and __deployment hooks__.

## Command Parameters

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-c --component <component>` | Start un-deployment for one  component or multiple (supplied as comma separated value) | |
| `-o --offset <component>` | Start un-deployment from specific component (handy when you want to restart un-deployment, and want to skip few from the beginning in the runlist)  | |
| `-l --limit <component>` | Stop un-deployment after desired (opposite to `--offset` flag)  | |
| `--profile` | Choose a specific un-deployment provider (defaults to `HUB_PROFILE` in `.env` file)  | |
| `--tty` <br> or `--no-tty` | Instructs if user wants to group outputs per component ]

## Common Parameters

These parameters applies across all extension commands

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-V --verbose` | extra verbosity for diagnostics | |
| `-h --help` | print help and usage message | |

## Usage Example

To un-deploy all components in the runlist:

```bash
hubctl stack undeploy
```

To un-deploy specific components with order defined in the run-list

```bash
hubctl stack undeploy -c "external-dns,cert-manager"
```


## See also

* [`hubctl stack deploy`](../hubctl-stack-deploy)
* [`hubctl stack init`](../hubctl-stack-init)
* [`hubctl stack configure`](../hubctl-stack-configure)
* [`hubctl stack rm`](../hubctl-stack-rm)
