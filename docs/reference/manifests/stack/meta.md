# Section: `meta`

This section defines metadata for the stack manifest. Metadata can be captured by automation tools

```yaml
version: 1                            # mandatory, stack manifest schema version
kind: stack                           # mandatory, defines a stack manifest
meta:                                 # optional
  name: happy-meal                    # optional human readable name
  brief: Happy Meal                   # optional, brief description of the stack
  fromStack: ../../stacks/base-stack  # optional, see FromStack
  license: Apache 2.0                 # optional, license applied to stack distribution
```

Every stack must define at least manifest `version` and `kind`. Other fields are optional.

Section `meta.fromStack` can enable inheritance of stack manifest from another stack. This will enable stack to inherit parameters values from another stack.
