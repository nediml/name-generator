# NAME GENERATOR
This project provides a web service that generates random names to identify objects among humans.

It provides two collections :
- **fr** : names and french adjectives
- **docker** : same names and adjectives as the Docker project

## General notes
- AWS is used for hosting all components
- Terraform is used for provisioning infrastructure
- Name generator service is configured to run, as a docker container, in Elastic container service (ECS)
- AWS CodeDeploy is used for deployment management

## Infrastructure setup
Terraform is used for infrastructure provisioning. All infra related code resides in `tf/`
Terraform Cloud is used for IaC pipeline management. 

<img src="https://raw.githubusercontent.com/nediml/name-generator/master/docs/infra.png" />

