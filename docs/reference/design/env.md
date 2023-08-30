# Environment Configuration

Values in hubfile can be stored in the version control system such as git. However not all parameter should be available in the repository. For example, credentials should be stored in a secure place. Hubctl allows to store values in environment variables.

__Environment__ configuration is a perfect example. Cloud credentials, Kubernetes, etc are the good examples

__Passwords__ and other __Secrets__ is another example of such parameters. Passwords should not be committed to the repository. Instead they should be passed in a separate way to the users. Don't store keys from the front door under the mat.

## Configuration

Environment variables are not stored in the hubfile. Instead they are stored in the `.env` file. This file is a symlink to the `.hub/<deployment-name>.env` file. This way allows to switch between different deployments of a stack and use different environment variables.

1. To __initialize__ such configuration run

```bash
hubctl stack init
```

Or if current directory already have an initialized stack. This is extra protection from accidentally overwriting existing configuration.

```bash
hubctl stack init --help
```

2. To __configure__ environment variables run

```bash
hubctl stack configure
```

Or if you want to trigger only environment variables checks run the following command

```bash
hubctl stack configure -r "env"
```

Command above will check all parameters marked with `fromEnv` and will ask user to provide values for them. Hubctl will see if variable is not exist in `.env` file and prompt user. Hubctl will also provide convenience suggestion to the user based on the following algorithm

1. If environment variable is defined, then use it
3. If environment variable is not defined, then use `default` value
3. If parameter has `empty: allow` then use empty value
4. Use previously provided value from the same environment variable
4. Use random value

You can change the value prompted by the hubctl.

> __Note:__ After value has been set, you can always change it in `.env` file.

### How to Switch Between Configurations

Hubctl allows to switch between different configurations. For example, you can have different configurations for different environments.

```bash
hubctl stack ls # list all available stacks
hubctl stack use <stack-name> # use the stack for the current directory
```

## Configure Programmatically

Hubctl extensions contains a `.env` parser written in bash. It has been available in `~/.hub/bin/dotenv` and automatically added to the `PATH` during the `hubctl stack <any>` command. You can use it to parse or set environment variables from your deployment hooks

For more details check

```bash
~/.hub/bin/dotenv --help
```

> __Note:__ `dotenv` parser maybe in the different if you decided to install hubctl extensions in the different location

## See Also

* [hubctl stack](../../../hubctl/cli/hubctl-stack) command
* [Parameters](../../manifests/stack/parameters) - reference guide
* [Hubctl Key Concepts](../)
