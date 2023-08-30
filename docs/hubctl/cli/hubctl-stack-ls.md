# Command: `hubctl stack ls`

Useful command when you have deployment multiple stacks from the one working directory it will help you to navigate across them

It prints stack domain name as an identifier and marks which has been set as a active with the `*` symbol

See example below

```bash
hubctl stack ls
# ACTIVE  STACK                 STATUS      TIMESTAMP
# *       disastrous-lundy-871  undeployed  2023-04-13T13:11:50
#         funny-ray-ray-795     deployed    2023-04-13T13:09:14
```

Most likely the stack has been initialized with `hubctl stack init` command however not yet configured (`hubctl stack configure`)

## See also

* [`hubctl stack use`](../hubctl-stack-use)
* [`hubctl stack`](../hubctl-stack)
