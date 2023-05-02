# Command: `hubctl stack`

Helps you to manage your stack deployments

## Sub-commands

Extensions provides following commands:

| Command   | Description
| --------- | ---------
| [`hubctl stack init`](../hubctl-stack-init) | Initialise a new stack deployment in the working directory |
| [`hubctl stack configure`](../hubctl-stack-configure) | Manage configuration before the deployment |
| [`hubctl stack deploy`](../hubctl-stack-deploy) | Apply deployment to target infrastructure |
| [`hubctl stack undeploy`](../hubctl-stack-undeploy) | Reverse deployment action |
| [`hubctl stack ls`](../hubctl-stack-ls) | See other stacks that has been initialized for the working directory |
| [`hubctl stack set`](../hubctl-stack-set) | Change a different current stack |
| [`hubctl stack rm`](../hubctl-stack-rm) | Delete configuration of a stack from working directory. This commands is non-reversible, and __doesn't run [`undeploy`](../hubctl-stack-undeploy)__

## Advanced Commands

These commands intended for advanced usage

| Command   | Description
| --------- | ---------
| [`hubctl stack backup`](/hubctl/cli/hubctl-stack-backup) | Stack backup/restore management (*if "backup" verb supported by at least one component in the stack)|
| [`hubctl stack elaborate`](/hubctl/cli/hubctl-stack-elaborate) | Reconcile defined parameters and a state |
| [`hubctl stack invoke`](/hubctl/cli/hubctl-stack-invoke) | Execute other verb rather than `deploy`, `undeploy` or `backup`. (*if verb supported by at least one component in the stack)|
| `hubctl stack explain` | Command reserved for state and parameters diagnostics |

## Common Flags

These parameters applies across all extension commands

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-V --verbose` | extra verbosity for diagnostics | |
| `-h --help` | print help and usage message | |
