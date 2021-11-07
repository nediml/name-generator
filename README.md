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

Infrastructure components:
- ECS - hosting the app as a container
- Application Load Balancer (ALB) - used as a router and load balancer
- CodeDeploy - used for deployment management

Below is the simplified infra diagram: 
<img src="https://raw.githubusercontent.com/nediml/name-generator/master/docs/infra.png" />


## Building and Deploying the application
For this purpose Github Actions are being used. Pipeline scripts are stored in `.github/` directory.

Building and deploying of the application happens in a following way:
1. On every push to the `master` branch pipeline is being invoked
2. Name generator application is built stored as a docker image
3. Built docker image is pushed to ECR
4. CodeDeploy helper lambda functions are being built and deployed
5. CodeDeploy Blue/Green deployment is created and invoked

### **Blue/Green deployment**  
CodeDeploy is performing Blue/Green deployment in a following way:  
**Step 1**: Deploying replacement task set  
**Step 2**: Test traffic route setup  
**Step 3**: Rerouting production traffic to replacement task set  
**Step 4**: Waiting for deployment to stabilizes  
**Step 5**: Terminate original task set  

More info: https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-steps-ecs.html#deployment-steps-what-happens

Below is a simple deployment diagram in case of Blue/Green deployment strategy:

<img src="https://raw.githubusercontent.com/nediml/name-generator/master/docs/deploy.png" />
- 

###