# What Is Hubctl

Hubctl does not replaces Infrastructure as Code tools such as Terraform, Kustomize, Helm, ARM etc. Instead it acts as a glue between them. It allows to split your infrastructure into reusable components and manage them as a single stack of components.

## How Does It Work

Each component has a set of expectations `requires` and provides something for another components `provides` and has a deployment script that uses one or few Infrastructure as Code technologies. Hubctl uses this information to configure your environment, deploy components in the right order, and carry on parameters between components.

The hubctl workflow consists of following steps:

* **Write**: You define components that you want to use in your stack, and what your stack of components will require form the environment. Such as which credentials to use for your Cloud Service Provider, or with Kubernetes cluster. Do you want to use publicly available DNS etc.

* **Configure**: Configure your stack before deployment. This means supply all inputs from the environments defined in the previous step. Other input will be provided as components outputs. Hubctl will validate that all required inputs are provided, configure remote state, DNS and other resources.

* **Deploy**: Deploy your stack. This will run deployment scripts for each component in the right order and carefully pass inputs from the environment or upstream component.

## Break Deployments Monolith

Hubctl allows to break your deployments into smaller pieces. This allows to reuse components across multiple stacks. For example you can have a component that deploys a Kubernetes cluster and reuse it across multiple stacks. Or you can have a component that deploys a database and reuse it across multiple stacks. More about use cases see in [here](../use-cases).

## See Also


