# When do You Need Hubctl?

When we created a Hubctl we had an idea to promote the best practices for infrastructure as code. We wanted to create a tool that would help us to manage our infrastructure as code in a consistent and repeatable way.

## Package manager for the Cloud

Operating Systems have got a package managers for ages now like `homebrew` for Mac and `choco` for Windows. It is able to download and install packages, resolve dependencies etc. But there is no such package manager for the cloud deployments.

Today we organize our infrastructure as code in the form of Terraform, Kustomize, Helm, ARM etc. Each of these tools solves solves a specific problem. When you find yourself in the situation when you need to multiple tools for your deployment, you end up with a lot of boilerplate code. Hubctl solves this problem by these integrations and provides a single interface to manage your infrastructure.

## Break-up monolithic deployments

We have seen when application deployment code was 60% of entire codebase. This makes deployment code a biggest component of your entire application. Similar to applications today split into microservices, we can also split our infrastructure into multiple components. This makes it easier to manage and maintain.

Hubctl provides mechanisms to manage your deployment as a stack of components. Each component can be deployed and managed independently and can use it's own deployment tool.

## Ephemeral Environments

Hubctl gives you a single place to deploy your environments. You can deploy your environments on demand and dispose them when you don't need them. This allows you to save money on your cloud bills.

## Run from Automation

Hubctl is designed to be used in automation. CI/CD pipelines, GitHub Actions, GitLab CI, Jenkins, ArgoCD, FluxCD, Tekton, Spinnaker, you name it. Hubctl can 
also send a call backs to your IT Service System so it can track the progress of your deployments.

