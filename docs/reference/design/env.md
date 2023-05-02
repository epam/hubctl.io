# Environment Variables

Values in hubfile can be stored in the version control system such as git. However not all parameter should be available in the repository. For example, credentials should be stored in a secure place. Hubctl allows to store values in environment variables.

Passwords is another example of such parameters. Passwords should not be committed to the repository. Instead they should be passed in a separate way to the users. Don't store keys from the front door under the mat.

## Initialize `.env` file

When stack has been initialized with the new command hubctl will create a `.env` file (simlink to the `.hub/<stack-name>.env` file) in the current directory. This file will contain environment variables for all parameters defined in the stack.

## Configure environment variables

When user run `hubctl stack configure` command for the first time, hubctl will ask user to provide values for all parameters marked with `fromEnv`. Hubctl will prompt user and add suggestion based on the following algorithm:
1. If environment variable is defined, then use it
3. If environment variable is not defined, then use `default` value
3. If parameter has `empty: allow` then use empty value
4. Use previously provided value from the same environment variable
4. Use random value 

You can change the value prompted by the hubctl.

> __Note:__ After value has been set, you can always change it in `.env` file.

