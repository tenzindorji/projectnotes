# Helm

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

## what is helm chart?
- Bundles of yaml files are call helm charts, can be published to others in public registries or download existing one.
- Sharing charts


## Architecture
- Clint , helm Cli
- Server, Tiller - runs on kubernetes cluster and creates components from yaml file inside kubernetes cluster
- Tiller Creates history of chart execution (Release management)
  - Tiller has toomuch of permission inside kubernetes which creates security concerns hence is was removed since helm 3. Now it is just a binary file.




## How to use them?

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
```
