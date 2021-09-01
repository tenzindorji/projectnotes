# Helm
- package manager for kubernetes
- performs value lookup in the template, separate variables in values.yml
- keeps old version and can easily rollback
- chart - templating

```
helm install myApp # Deploy to kubernetes cluster
helm upgrade myApp #used for scaling or refreshing configuration
helm rollback myApp #rollback back to previous last known configuration
helm Package myApp #Upload configuration to repository
```
