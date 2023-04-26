# Command: `hubctl stack set`

Set stack by it's name as a current.

Example

```bash
hubctl stack ls
# ACTIVE  STACK                 STATUS      TIMESTAMP
# *       disastrous-lundy-871  undeployed  2023-04-13T13:11:50
#         funny-ray-ray-795     deployed    2023-04-13T13:09:14

hubctl stack set "funny-ray-ray-795"

hubctl stack ls
# ACTIVE  STACK                 STATUS      TIMESTAMP
#         disastrous-lundy-871  undeployed  2023-04-13T13:11:50
# *       funny-ray-ray-795     deployed    2023-04-13T13:09:14
```

## See also

* [`hubctl stack init`](/hubctl/cli/hubctl-stack-init)
* [`hubctl stack configure`](/hubctl/cli/hubctl-stack-configure)
* [`hubctl stack ls`](/hubctl/cli/hubctl-stack-ls)
* [`hubctl stack rm`](/hubctl/cli/hubctl-stack-unconfigure)
* [`hubctl stack deploy`](/hubctl/cli/hubctl-stack-deploy)
* [`hubctl stack undeploy`](/hubctl/cli/hubctl-stack-undeploy)
