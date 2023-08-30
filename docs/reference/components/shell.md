# Shell Component

Shell component is a component that can be deployed using shell scripts. This is the easiest and most flexible way how to deploy a component.

Minimal component structure would look liek the following

```text
./
├── hub-component.yaml  # component manifest
├── deploy.sh           # shell script to deploy the component
└── undeploy.sh         # shell script to undeploy the component
```

## Conventions

There are no specific variables that are expected to be passed to the shell script.

Scripts expected:

* `deploy.sh` - script to deploy the component (mandatory)
* `undeploy.sh` - script to undeploy the component (mandatory)
* `<verb>.sh` - any other script that can be used to perform any other action

You can define additional variables in the `hub-component.yaml` file.

```yaml
lifecycle:
    verbs:
    - deploy
    - undeploy
    - bar-verb
```

You can call this verb by running the following command

```bash
hubctl stack invoke "foo-component" "bar-verb"
```

## Best practices

Component should always have a `undeploy.sh` script. Good design says the deployment of any component should be revertible (verb: undeploy)

Parametrise your shell scripts via environment variables. You can define environment variables in the `hub-component.yaml` file.

Parametrsise your configuration via templates.

## See Also

* [hub stack](../../../hubctl/cli/hubctl-stack/)
* [hub stack invoke](../../../hubctl/cli/hubctl-stack-invoke/)
