# Command: `hubctl stack use`

Set stack by it's name as a current.

Example

```bash
hubctl stack ls
# ACTIVE  STACK                 STATUS      TIMESTAMP
# *       disastrous-lundy-871  undeployed  2023-04-13T13:11:50
#         funny-ray-ray-795     deployed    2023-04-13T13:09:14

hubctl stack use "funny-ray-ray-795"

hubctl stack ls
# ACTIVE  STACK                 STATUS      TIMESTAMP
#         disastrous-lundy-871  undeployed  2023-04-13T13:11:50
# *       funny-ray-ray-795     deployed    2023-04-13T13:09:14
```

## See also

* [`hubctl stack ls`](../hubctl-stack-ls)
* [`hubctl stack`](../../stack)
