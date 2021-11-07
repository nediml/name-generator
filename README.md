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
After this step, Lambda function will validate the setup of test task set  
**Step 3**: Rerouting production traffic to replacement task set  
After this step, Lambda function will validate the setup of production task set    
**Step 4**: Waiting for deployment to stabilize  
**Step 5**: Terminate original task set  

More info: https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-steps-ecs.html#deployment-steps-what-happens

Below is a simple deployment diagram in case of Blue/Green deployment strategy:

<img src="https://raw.githubusercontent.com/nediml/name-generator/master/docs/deploy.jpg" />
- 

## HOW TO DEPLOY
Before initiating the deployment check the following:  
1. Config files used in deployment execution:  
  a. `.github/workflows/codedeploy/appspec.yaml` - info about the service to be deployed and validation lambda functions  
  b. `.github/workflows/codedeploy/lambda` - lambda functions to be used for validating test and production task sets  
  c. `.github/workflows/codedeploy/create-deployment.yaml` - info for creating and initiating new deployment  
2. `.github/workflows/cd.yaml` - deployment pipeline definition  

### **Initiating the deployment**
1. Push changes to the `master` branch.
2. Monitor the build and deployment pipeline in Github Actions: https://github.com/nediml/name-generator/actions  
3. Monitor the deployment execution in CodeDeploy: https://console.aws.amazon.com/codesuite/codedeploy/deployments?region=us-east-1  

Note that it is possible to cancel and rollback at any point using CodeDeploy console at the link above.

Application is reachable at: 
- Prod task set: http://tf-lb-2021110609264334060000000b-792189563.us-east-1.elb.amazonaws.com:80
- Test task set: http://tf-lb-2021110609264334060000000b-792189563.us-east-1.elb.amazonaws.com:81