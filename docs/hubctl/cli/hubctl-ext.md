# Command: `hubctl ext`

This is a utility command to manage user defined extensions.

By default extensions installed in `~/.hub`. However this can be any directory available in the PATH.

User can define their own extensions and place them in the extensions directory or in the `PATH`.

```bash
cat << EOF > ~/.hub/hub-hello
#!/bin/sh
echo "Hello from custom extension"
EOF

chmod +x ~/.hub/hub-hello

hubctl ext hello 
# Hello from custom extension
```

| Flag   | Description | Required
| :-------- | :-------- | :-: |
| `-h --help` | print help and usage message | |

## See Also

* [`hubctl extensions`](../hubctl-extensions)
* [`hubctl`](../../cli)
