# Kubernetes Tutorials

This is a set of tutorials that describes how to use hubctl to deploy a stack on existing Kubernetes cluster.

## In This Tutorial

This tutorials covers the following topics:

* How to install and use Rancher Desktop Kubernetes
* How to use hubctl to deploy a stack on existing Kubernetes cluster

## Install Rancher Desktop

Rancher Desktop is an app that provides container management and Kubernetes on the desktop. It is available for Mac (both on Intel and Apple Silicon), Windows, and Linux.
You can read the full documentation about Rancher Desktop [here](https://docs.rancherdesktop.io/).

An open-source desktop application for Mac, Windows and Linux. Rancher Desktop runs Kubernetes and container management on your desktop. You can choose the version of Kubernetes you want to run.
Each component knows how to deploy itself and export facts about deployment configuration in the well-known form of parameters. So other component would use this as an input.

How to install and configure Rancher Desktop on Windows OS:

1. Open link with Rancher Desktop [documentation](https://docs.rancherdesktop.io/1.6/getting-started/installation#windows)
2. You need to upgrate WSL2 version on your computer.
[Manual installation steps](https://learn.microsoft.com/en-us/windows/wsl/install-manual#step-1---enable-the-windows-subsystem-for-linux)
3. Install [Ubuntu](https://learn.microsoft.com/en-us/windows/wsl/install-manual#step-6---install-your-linux-distribution-of-choice)
4. Download and install Rancher Desktop https://rancherdesktop.io/
5. Check your Rancher Desktop settings "Preferences"-> WSL. WSL has to a checkbox with Ubuntu.
6. Open Windows PowerShell as Administration and run
```PowerShell
wsl -l -v
```
Rancher-desktop and Ubuntu have to "Running" states.

* Open Ubuntu terminal and run commands
```bash
docker
```
```bash
sudo apt-get update

sudo apt install docker.io
```
* Check the version of the docker
```bash
docker version
```
```bash
docker ps
```
You have to see all containers related to rancher-desktop kubernetes.
And  if you have a message "Got permission denied while trying to connect to the Docker ..."
something needs to be done so $USER always runs in group `docker` on the `Ubuntu` WSL

```bash
sudo addgroup --system docker
```
```bash
sudo adduser $USER docker
```
* [Install kuberctl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/). To test connectivity to a kubernetes cluster,
   open `Ubuntu terminal` and run commands
```bash
kuberctl version
```


How to use hubctl to deploy a stack on existing Kubernetes cluster:
1. Run the commands and test your Rancher Desktop Kubernetes:
```bash
rdctl version
```
```bash
docker images
```
2. To run hubctl the use following commands:
```bash
hubctl stack init
```
```bash
hubctl stack deploy
```
How to install hubctl on your local workstation you can find [here](../../install)
