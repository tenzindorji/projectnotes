#Jenkins Pipeline
- commit module -- version controlled system
- build module (UT/IT CI Jenkins) -- Selenium for testing
- Testing Environment (User acceptance and load testing)
- Production ready

# What is Jenkin Pipeline(Jenkins file)
- two ways of writing pipeline
  - Declarative pipeline  - Groovy syntax
    - code defined within pipeline block
    ```
    pipeline {

    }
    ```
    - versioned control
    -

  - Scripted pipeline - Groovy syntax
    - code is defined within node block
    ```
    node {

    }
    ```
    - written on jenkins UI

# Agent :
- Instruct Jenkins to allocate an executor for the builds.
## Agent have 4 Parameters:
- Any: runs pipeline /stage on any available agent
- None: Applied at the root of the pipeline, it indicates that there is no global agent for entire pipeline\
and each stage must specify its own agent
- Label : Executes the pipeline/stages on the labelled agent.
- Docker: uses docker container as execution env for the pipeline or a specific stage

```
pipeline {
  agent {
    docker {
      image 'ubuntu'
    }
  }

}
```

#Stages:
  - It contains all the work and each stage performs a specific task
  ```
  pipeline {
    agent any
    stages {
      stage ('build') {
        ...
      }
      stage ('test') {
        ...
      }
      stage ('deploy') {
        ...
      }
    }

  }
  ```  
# Steps
  - Steps are carried out in a sequence to execute a stage.
  ```
  pipeline {
    agent any
    stages {
      stage ('build') {
        steps {
          echo 'running build phase...'
        }
      }
    }
  }
