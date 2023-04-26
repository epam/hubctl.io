# Section: `meta`

This section defines metadata for the component manifest. Metadata can be captured by automation tools

```yaml
version: 1                            # mandatory, component manifest schema version
kind: component                           # mandatory, defines a component manifest
meta:                                 # optional
  name: happy-meal                    # optional human readable name
  brief: Happy Meal                   # optional, brief description of the component
  license: Apache 2.0                 # optional, license applied to component distribution
```

Every component must define at least manifest `version` and `kind`. Other fields are optional.
