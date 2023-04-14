# DIY Component

This tutorial will show you how to create a component from scratch. We will start with a minimalistic component and then we will add more features to it.

Component is the minimal deployment unit that hubctl can manage. Good component should have few properties:

* Idenmpotent - component with the same parameters can be deployed with the same result multiple times. If component has been deployed, then it can be deployed again without any side effects.
* Generic - good component reusable this means generic enough. `hub-component.yaml` provides such abstraction. Then specific configuration will be defined via `hub.yaml` or `parameters.yaml` file on the stack level.

Stack consists of one or multiple components. Good stack defines

* Components definition and deployment order
* Parameters that are passed to the components from environment
* Parameters that are passed between components
* Optional deployment hooks that can be used to execute custom logic before or after deployment of the component or a stack

## Component structure

Each component knows how to deploy itself and export facts about deployment configuration in the well-known form of parameters. So other component would use this as an input.

Hub component contains the following:

1. `hub-component.yaml` - file with input and output parameters
2. `deploy` and `undeploy` provisioning scripts. This however optional if component is using well known deployment tool such as `terraform`, `helm` or `kustomize`.

In the nutshell - parameters defined in `hub-component.yaml` abstracts user from concrete provisioning technology and allows maintainer of the component improve or even change provisioning technology without breaking compatibility with the other components.

### Deploy a minimalistic component

1. Create a new directory `components/hello-shell`
2. Create a file `components/hello-shell/hub-component.yaml` and add minimalistic content

```yaml
kind: component
version: 1
parameters:
- name: hub.componentName
  env: COMPONENT_NAME
```

3. Create a `deploy.sh` file and add execution rights to it. Here is an example

```bash
cat << EOF > `components/hello-shell/deploy.sh`
#!/bin/sh
echo "Component $COMPONENT_NAME deployed successfully!"
EOF
chmod +x `components/hello-shell/deploy.sh`
```

3. Create deployment reverse script: `undeploy.sh`

```bash
cat << EOF > `components/hello-shell/undeploy.sh`
#!/bin/sh
echo "Component: $COMPONENT_NAME has been successfully undeployed"
EOF
chmod +x `components/hello-shell/undeploy.sh`
```

4. Add a component reference to Hubfile (`hub.yaml`)

```yaml
kind: stack
version: 1
components:
- name: hello-shell
  source:
    dir: components/hello-shell
```

5. And we are ready to deploy

```bash
hubctl stack init -f `hub.yaml`
hubctl stack deploy
```

### Add a parameter

1. Add new parameter to the `components/hello-shell/hub-component.yaml`

```yaml
kind: component
version: 1
parameters:
- name: hub.componentName
  env: COMPONENT_NAME
- name: message
  value: foo
  env: MESSAGE
```

2. Modify `components/hello-shell/deploy.sh` script. You should get something like

```bash
#!/bin/sh
echo "Component $COMPONENT_NAME is saying: $MESSAGE"
echo "Component $COMPONENT_NAME deployed successfully!"
```

3. Add parameters to the hubfile (`hub.yaml`) to include parameter

```yaml
kind: stack
version: 1
meta:
  name: My first deployment
components:
- name: my-first-component
  source:
    dir: components/hello-shell
parameters:
- name: message
  value: bar
```

4. Run a deployment

```bash
hubctl stack deploy
#
# Component my-first-component is saying: bar
# Component my-first-component deployed successfully!
```

### Add a second component and override the parameter

Modify a hubfile so it would look as the following:

```yaml
kind: stack
version: 1
meta:
  name: My first deployment
components:
- name: my-first-component
  source:
    dir: components/hello-shell
- name: my-second-component
  source:
    dir: components/hello-shell
parameters:
- name: message
  value: bar
- name: message
  component: my-second-component
  value: baz
```

2. Run deployment

```bash
hubctl stack deploy
# Component my-first-component is saying: bar
# Component my-first-component deployed successfully!
# Component my-second-component is saying: baz
# Component my-second-component deployed successfully!
```

### Add a template to the component

1. Add a file that would look like the following

```bash
cat << EOF > `components/hello-shell/message.txt.template`
The cryptic message says: ${message}
EOF
```

2. Update `components/hello-shell/hub-component.yaml` so it would look like:

```yaml
kind: component
version: 1
parameters:
- name: hub.componentName
  env: COMPONENT_NAME
- name: message
  value: foo
  env: MESSAGE
templates:
  files:
  - "*.template"
```

3. Modify `components/hello-shell/deploy.sh` so it would look like the following
```bash
#!/bin/sh
echo "Component $COMPONENT_NAME is saying: $MESSAGE"
# here we interact with template file... it has been already rendered
cat "message.txt"

echo "Component $COMPONENT_NAME deployed successfully!"
```

4. Deploy the stack

```
hubctl stack deploy
# Component my-first-component is saying: bar
# The cryptic message says: bar
# Component my-first-component deployed successfully!
# Component my-second-component is saying: baz
# The cryptic message says: baz
# Component my-second-component deployed successfully!
```

## Technology specific components

This article is not a reference guide, we do skip many things... Now we will jump into the more advanced topics. Until then we were writing a sudo component using a free form. Now we will use arguably oppinionated deployment steps however, you don't required to write your own deployment script

At present we support following technologies

* [Component Helm](hub-component-helm.md)
* [Component Kustomize](hub-component-kustomize.md)
* [Component Terraform](hub-component-terraform.md)
* [Component ARM Deployment Template](hub-component-arm.md)
