# OSS Conflict Handling

## Introduction
This repo contains the OSS Conflict Handling Application chart.

#### Charts
This directory contains the OSS Conflict Handling Integration Chart.
See the [OSS Conflict Handling Docs](docs/oss_conflict_handling_chart.md)
for more details

## Install, Uninstall and Upgrade

### Prerequisites

Following is a list of prerequisites for successful deployment of the helm chart.
Obviously, `helm` and `kubectl` needs to be installed and a kubeconfig to with access to a Kubernetes cluster.

#### Helm repo

Helm repo needs to be added:
eric-oss-drop-helm-local        https://arm.seli.gic.ericsson.se/artifactory/proj-eric-oss-drop-helm-local

If `helm repo list` does not show it, add it:
```bash
helm repo add eric-oss-drop-helm-local https://arm.seli.gic.ericsson.se/artifactory/proj-eric-oss-drop-helm-local --username=signum --password=<PASSWORD>
helm repo update
```

#### Namespace on kubernetes cluster

Skip this step if you are using an existing EIC deployment.

```bash
NAMESPACE=emolger
kubectl create namespace ${NAMESPACE}
```

#### Pull-secret for docker image download

This step is only required if there's no pull secret already on the namespace.
EIC deployments typically use `k8s-registry-secret`.

```bash
NAMESPACE=emolger
DOCKER_USERNAME=ossapps100
DOCKER_PASSWORD=OSS_too_MUCH_fun_AND_much_MORE_coming_100
kubectl create secret docker-registry arm-pullsecret \
--docker-server=armdocker.rnd.ericsson.se            \
--docker-username=$DOCKER_USERNAME                   \
--docker-password=$DOCKER_PASSWORD                   \
--docker-email=example@ericsson.com                  \
--namespace=$NAMESPACE
```

Note that the name of the pull-secret is `arm-pullsecret`. This needs to be set at `helm install`, otherwise the deploy fails with image pull issues.

> Note: Do not use your signum and password above as these secrets are opaque and readable after base64 decode.
> Use a functional user's credentials.

#### Database secret

Skip this step if you are using an existing EIC deployment. EIC deployments already have a `eric-eo-database-pg-secret`.

Most of the DB services in EIC use a common DB credential secret.
The default name of this secret as of now is `eric-eo-database-pg-secret` (from OSS Common Base).

To create that manually on an empty namespace, execute:

```bash
kubectl create secret generic eric-eo-database-pg-secret \
--from-literal=custom-user=customname   \
--from-literal=custom-pwd=custompwd     \
--from-literal=super-pwd=superpwd       \
--from-literal=super-user=postgres      \
--from-literal=metrics-pwd=metricspwd   \
--from-literal=replica-user=replicauser \
--from-literal=replica-pwd=replicapwd   \
--namespace=$NAMESPACE
```

Other resources are created during deployment of the helm chart.

### Package
To verify your changes and create the helm chart package, execute:

```bash
cd charts/eric-oss-conflict-handling

# Build Chart.lock
helm dependency update
helm dependency build

# Inspect that helm template is successful and reflects your changes (if there's any)
helm template .

# Package helm chart:
helm package .
```

### Install
After helm chart package is created, install using that file as below.

> PVC is disabled in below command, PVC is not required for test deployments.

```bash
NAMESPACE=emolger

helm install eric-oss-conflict-handling ./eric-oss-conflict-handling-0.1.0.tgz \
--set global.pullSecret=arm-pullsecret      \
--set global.log.steamingMethod=indirect    \
--set eric-oss-conflict-manager-database-pg.persistentVolumeClaim.enabled=false \
--wait                                      \
--timeout 300s                              \
--namespace=${NAMESPACE}
```

After install is successful, verify all pods are running:

```bash
$ kubectl get pods --namespace=${NAMESPACE} | grep conflict
eric-oss-conflict-manager-database-pg-0                  2/2     Running     0          6m53s
eric-oss-conflict-manager-database-pg-1                  2/2     Running     0          6m37s
eric-oss-conflict-manager-poc-5f58579657-k7cc7           1/1     Running     0          6m53s
```

### Upgrade
Upgrade example re-using values from install:

```bash
helm upgrade eric-oss-conflict-handling ./eric-oss-conflict-handling-<NEW_VERSION>.tgz \
--reuse-values \
--namespace=${NAMESPACE}
```

### Uninstall
To remove the deployment, simply run helm uninstall as follows.

```bash
helm uninstall eric-oss-conflict-handling --namespace=${NAMESPACE}
```

### Key people of the project
  - PO: <team_po>
  - Guardians: (Code reviews, approvals, house rules etc.)

### Contact
  - Team Agora
    [PDLTEAMAGO@pdl.internal.ericsson.com](mailto:PDLTEAMAGO@pdl.internal.ericsson.com)
