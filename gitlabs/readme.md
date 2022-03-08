## What is gitlab?
- is an opensource software development platform
- source code management system
- CI/CD
- Complete Devops Platform


## Difference between git and gitlab
- git is version control system

## why use Gitlab?
- gitlab is a source code management system
- gitlab enables collaboration among a team of developers with the gitlab flow
- gitlab Built-in CI/CD functionality
- It can integrate with other tools
- and A plethora of other features

## Gitlab terms
- Group
  - Allow you to manage settings across multiple projects
  - Logically categorize multiple users or projects
  - Provide a cross-project view
- Project
  - A container for git repository
  - Built in CI/CD
  - Issue tracking
  - Collaboration tools such as merge
- Member
  - Users or groups that have access to a project
  - Members are assigned to roles
  - Member roles included permissions to perform actions on projects or groups
- Merge Requests
  - A request to merge one branch into another
  - Merge requests provide a space to have conversation with the team about the changes on a branch
  - It is the central place through which changes are reviewed and verified
- Issue
  - An issue is a way to track work related to a gitlab project
  - Issues can be used to report bugs, track tasks, request new features, ask questions and more
  - Your development workflow should begin with an issue

## Interface
- gitlab.com

## CI/CD in Gitlab Learning objectives
- Demonstrate an understanding of how gitlab pipelines integrate with a gitlab project
- implement gitlab pipelines in your own gitlab projects
- write a gitlab pipeline that produces artifacts
- write a gitlab pipeline that caches dependencies
- write a gitlab pipeline that uses variables
- Describe that anatomy of a gitlab pipeline

## CI/CD terminology
- Pipeline
  - The top-level component used to define a CI/CD process
  - within a pipeline, we can degine stages and jobs
- Jobs
  - Associated with stages
  - Define the actual steps to be executed(such as running commands to compile code)
- Stages
 - Define the chronological order of jobs
- Runners
 - Open-source application that executes the instructions defined within jobs
 - It can be installed on your local machine, a cloud server or on-perm
 - Shared runners are hosted by gitlab
 - Specific runners

 
