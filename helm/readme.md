# Helm
- package manager for kubernetes, collecting kubernetes yaml and storing in repository
- performs value lookup in the template, separate variables in values.yml
- keeps old version and can easily rollback
- chart - templating(go templates) - bundles of yaml files
- sharing chart - reusable
- Has two parts -- tiller is no available in latest version of helm due to security reason(too much permission)
  - helm client CLI
  - Tiller at server side - stores history for rollback purpose.

```
helm install myApp # Deploy yaml files to kubernetes cluster
helm upgrade myApp #used for scaling or refreshing configuration
helm rollback myApp #rollback back to previous last known configuration
helm Package myApp #Upload configuration to repository
```
# Directory structure
```
mychart/ # name of the helm chart folder
  Chart.yaml # meta info about chart, name, version, list of dependencies
  values.yaml # Default values for template files
  charts/ # Folder chart dependencies
  templates/ # actual template files
  ...
```
