# Helm
- package manager for kubernetes, collecting kubernetes yaml and storing in repository. Helm is not just package manager but more than that
- performs value lookup in the template, separate variables in values.yml
- keeps old version and can easily rollback
- chart - templating(go templates) - bundles of yaml files
- sharing chart - reusable
- Has two parts -- tiller is no available in latest version of helm due to security reason(too much permission)
  - helm client CLI
  - Tiller at server side - stores history for rollback purpose.

## What is helm?
  - package manager for kubernetes, package YAML files.
  - Avoid yaml duplication
  - Allows to bring all the yaml file together, whats call a chart
  - Charter have a name, description and version
  - Charter groups all the yaml files together in a  template folder
  - To make charter resuable, it has a ability to inject values as parameters
  - We can deploy chart and inject the app1 and reused for app2
  - Allows values file
  - Performs value lookup in the template, separate variables in values.yml
  - Keeps old version and can easily rollback
  - Chart - templating
  - It is Templating Engine
  - Inheritance
  - reduce indent errors

## what is helm chart?
- Bundles of yaml files are call helm charts, can be published to others in public registries or download existing one.
- Sharing charts
- can versioned deployments
- can rollback deployments


## Architecture
- Clint , helm Cli
- Server, Tiller - runs on kubernetes cluster and creates components from yaml file inside kubernetes cluster
- Tiller Creates history of chart execution (Release management)
  - Tiller has toomuch of permission inside kubernetes which creates security concerns hence is was removed since helm 3. Now it is just a binary file.


## How do you version control deployments?
- using Helm chart

## Lifecycle Management
- Update, rollback, config management, testing
- repeatability




## How to use them?
```
get the stable version from https://github.com/helm/helm and go to releases

curl -LO https://get.helm.sh/helm-v3.8.1-linux-386.tar.gz
tar -C /tmp/ -zxvfhelm-v3.8.1-linux-386.tar.gz
mv /tmp/linux-386/helm  /usr/local/bin/helm
chmod +x /usr/local/bin/helm
```

## When to use them?

## Use Case
- most of the time, component configs looks like same, except the name.
- Define common blueprint for all the microservices
- Dynamic values are replaces by placeholders
- Values defined either via yaml file or with --set flag
- Practical for CI/CD
- Deploy same set of applications across different environments
- Provides  Release Management

## Helm Chart Structure
-
```
mychart/ # name of the chart
  Chart.yaml  # Meta info about chart
  values.yaml # values for the template files, default values and can be override later
  charts/     # this folder contains chart dependencies
  templates/  # the actual template files
  ...
```

```
apiVersion: v1
kind: Pod
Metadata:
  name: {{ .Values.name }}

spec:
  containers:
  - name: {{ .Values.container.name }}
    image: {{  .Values.container.image }}
    port: {{ .Values.container.port }}
```

All the values are defined in external file call values.yaml

```
name: my-app
container:
  name: my-app-container
  image: my-app-image
  port: 9000
```

```
helm install myApp # Deploy to kubernetes cluster, gets the values from values.yaml file
helm upgrade myApp #used for scaling or refreshing configuration
helm rollback myApp #rollback back to previous last known configuration
helm Package myApp #Upload configuration to repository
helm search <keyword>

helm install --values=my-values.yaml <chartname> # override default values, it will result to .Values object which is merged between two values files
helm install --set version=2.0.0 # override default value using set flag.

helm test $(helm last) #
helm delete $(helm last)

helm list # shows the revision of deployments
```

## Config Map change
- Kubernetes doesn't automatically starts pod when there is change in config map.
- Helm can perform pod restart when config map is updated.
```
kind: Deployment
spec:
  template:
    metadata:
      annotations:
        checksum/config: {{ include (print $.Template.basePath "/configmap.yaml"). | sha256sum }}
```

`helm upgrade <nameofapp> <folder name example-app(chart name )> --values ./example-app/example-app.values.yaml`



## Helm Jenkins Pipeline
1. commit code (git)
2. commit trigger jenkins Pipeline
3. Jenkins build image and test
4. Image is pushed to container repository
5. Jenkins pulls the repository helm
6. image is deployed to Kubernetes  


## Helm templating
- **Test the rendering of the template created**
`helm template <app-name> chartname(folder name and path)`
- **Install app using chart**
`helm install example-app ../example-app`\

`helm list`

`kubectl get po`

`helm delete <app-name>`


## If and Else Statement in Deployment files with values
