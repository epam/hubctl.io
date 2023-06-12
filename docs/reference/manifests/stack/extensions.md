# Section `extension`

This section is not exposed into parameters

This section will has been dedicated to various hubctl extensions. Hubctl will ignore syntax checks inside of this section. However various extensions may require a specific structure.

```yaml
extensions:                               # optional
  include:                                # optional, additional parameter files         
  - params.yaml 
  - params-env.yaml
  init:                              # optional, steps activated during `hubctl stack init`
  - bin/my-custom-init.sh            # example, you can define custom scripts here
  configure:                              # optional, steps activated during `hubctl stack configure`
  - aws
  - kubernetes
  - bin/my-custom-configure.sh            # example, you can define custom scripts here
  deploy:
    before:
    - kubernetes                          # optional, steps activated on `hubctl stack deploy` but before actual deployment of components
    - bin/my-custom-pre-deploy.sh         # example, you can define custom scripts here
    after:                                # optional, steps activated on `hubctl stack deploy` but after actual deployment of components
    - inventory-configmap               
  undeploy:                               # optional, steps activated during `hubctl stack undeploy`
    before:
    - bin/my-custom-pre-undeploy.sh
    after:
    - bin/my-custom-post-undeploy.sh
```

## Referring another stack manifest file

Note: This is a good practice to split parameters from hub.yaml into it's own file params.yaml or even a series of params.yaml files. The parameter files can be referenced in hub.yaml as the following

```yaml
extension:
  include:
  - params.yaml
```

