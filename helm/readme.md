# Helm
- package manager for kubernetes
- Avoid yaml duplication
- Allows to bring all the yaml file togather, whats call a chart
- Charter have a name, description and version
- Charter groups all the yaml files togather in a  template folder
- To make charter resuable, it has a ability to inject values as parameters 
- We can deploy chart and inject the app1 and reused for app2
- Allows values file
- Performs value lookup in the template, separate variables in values.yml
- Keeps old version and can easily rollback
- Chart - templating

```
helm install myApp # Deploy to kubernetes cluster
helm upgrade myApp #used for scaling or refreshing configuration
helm rollback myApp #rollback back to previous last known configuration
helm Package myApp #Upload configuration to repository
```
