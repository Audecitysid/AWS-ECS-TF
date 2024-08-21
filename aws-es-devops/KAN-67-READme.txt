AWS ECS ELK, grafana, promethius, glitchtip deployment on ECS via Fargate and EC2 exposed via ALB

Stage 1. Building Docker Images 

Before running the code in terraform, we need to create a repo in AWS ECR This repo will be 
used to store some custom docker images.

The guidance to create a repo can be found here : https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html


After creating the repo go to directory KAN-67\aws-es-devops\docker-images here I have placed files 
to build the custom docker images of elastic search and logstash

## Prerequisites

- Docker installed on your machine.
- AWS CLI installed and configured with necessary access rights.
- An ECR repository created for each service.

go to folder \elastisearch

run :

docker build -t my-elasticsearch .

1. aws ecr create-repository --repository-name my-elasticsearch-repo

2. aws ecr get-login-password --region region | docker login --username AWS --password-stdin 123456789012.dkr.ecr.region.amazonaws.com

3. docker tag my-elasticsearch:latest 123456789012.dkr.ecr.region.amazonaws.com/my-elasticsearch-repo:latest

4. docker push 123456789012.dkr.ecr.region.amazonaws.com/my-elasticsearch-repo:latest

5. aws ecr describe-images --repository-name my-elasticsearch-repo

With these steps, your Docker image will be available in AWS ECR and can be used across AWS services that integrate with ECR, such as Amazon ECS.
now go to folder \logstash and repeat the same above steps

Now you have uploaded the docker images to AWS ecr... we will be needing the URI of these 
images so copy them to a side.

go to KAN-67\aws-es-devops\terraform\modules\logstash_mod\ecs\main.tf
go to line 184 in resource "aws_ecs_task_definition" "logstash" 
in this change 

 container_definitions = jsonencode([
    {
      name               = "logstash"        # here change the below URI to the URI of your logstash docker image
      image              = "0119512929933.dkr.ecr.us-east-1.amazonaws.com/docker-images-nvir:latest" 
      cpu                = 8192


next go to KAN-67\aws-es-devops\terraform\dev\ecs-cluster\main.tf

in this you will find the following code : 



module "ecs-cluster" {
  source = "../../modules/ecs-cluster"

  account_id = var.account_id
  env        = var.env
  project    = var.project
  region     = var.region
                            #  # here change the below URI to the URI of your elastic search docker image
  docker_image_url_es = "051591403833.dkr.ecr.us-east-1.amazonaws.com/docker-images-nvir:v1.0"
}


 

please note that we are running this code on Terraform v1.9.4 on windows_amd64

Step 1. go to KAN-67\aws-es-devops\terraform\dev\network
and run 

terraform init
terraform validate
terraform apply -var-file ../env.tfvars  

this is going to create all the network modules like vpc, subnets etc



Step 2. go to KAN-67\aws-es-devops\terraform\dev\ecs-iam-profile

terraform init
terraform validate
terraform apply -var-file ../env.tfvars

Step 3. go to KAN-67\aws-es-devops\terraform\dev\ecs-ec2

terraform init
terraform validate
terraform apply -var-file ../env.tfvars



Step 3.1 go to the file KAN-67\aws-es-devops\terraform\modules\ecs-cluster\variables.tf

in this file you will find : 

variable "docker_image_url_es" {
  type = string
}

variable "vpc_id" {
  type = string
  default="vpc-0cfd003c32881640e"
}

variable "subnets" {
  default = ["subnet-02c1ec5a5228083ce", "subnet-038d7e2bf6ebb2494"]   # change these to your subnet ids
}

Step 4. go to KAN-67\aws-es-devops\terraform\dev\ecs-cluster

terraform init
terraform validate
terraform apply -var-file ../env.tfvars


NOTE 1 : If you are doing this first time or have destroyed VPC OR Subnets OR Security groups 
you will have to pass their new IDs in the main.tf files of the modules (kibana , logstash , grafana , promethius and glitchtip)
in every main.tf file you will find the module :


module "ecs" {
  source             =  "../../modules/kib_mod/ecs"


  # replace with your own VPC id
  vpc_id             = "vpc-0cfd003c32881640e"


  # replace this with you own subnet ids :
  public_subnets     = ["subnet-_______________" , "subnet-_________________"]
  private_subnets    = ["subnet-_______________" , "subnet-_________________"]
  availability_zones = ["us-east-1a" , "us-east-1b" , "us-east-1c"]
  task_definitions   = var.task_definitions
  target_groups      = var.target_groups


# replace this with you own security group ids :
  existing_security_group     = "sg-_________________"

  
  alb_arn = data.terraform_remote_state.ecs_cluster.outputs.alb_arn

}



Step 5. go to KAN-67\aws-es-devops\terraform\dev\kib_dev\  (make the changes in main.tf as mentioned in note)

terraform init
terraform validate
terraform apply


Step 6. go to KAN-67\aws-es-devops\terraform\dev\logstash_dev\ (make the changes in main.tf as mentioned in note)

terraform init
terraform validate
terraform apply

Step 7. go to KAN-67\aws-es-devops\terraform\dev\grafana_dev\ (make the changes in main.tf as mentioned in note)

terraform init
terraform validate
terraform apply

Step 8. go to KAN-67\aws-es-devops\terraform\dev\promethius_dev\ (make the changes in main.tf as mentioned in note)

terraform init
terraform validate
terraform apply

Step 9. go to KAN-67\aws-es-devops\terraform\dev\glitchtip_dev\ (make the changes in main.tf as mentioned in note)

terraform init
terraform validate
terraform apply


NOTE 2: If you wanna delete and re-deploy any specific service then you should try to ensure 
that the ALB listners , target groups , log groups and cluster are deleted via terraform destroy
or manually. If you get the error Entity already exists then feel free to delete that Entity
Author: Siddhesh Dhomane : https://www.linkedin.com/in/siddhesh-dhomane-7396011a9/