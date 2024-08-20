

Step 1. go to elastic-search\aws-es-devops\terraform\dev\network
and run 

terraform init
terraform validate
terraform apply -var-file ../env.tfvars  

this is going to create all the network modules like vpc, subnets etc

Step 2. go to elastic-search\aws-es-devops\terraform\dev\ecs-iam-profile

terraform init
terraform validate
terraform apply -var-file ../env.tfvars

Step 3. go to elastic-search\aws-es-devops\terraform\dev\ecs-ec2

terraform init
terraform validate
terraform apply -var-file ../env.tfvars

Step 4. go to elastic-search\aws-es-devops\terraform\dev\ecs-cluster

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



Step 5. go to elastic-search\aws-es-devops\terraform\dev\kib_dev\  (make the changes in main.tf as mentioned in note)

terraform init
terraform validate
terraform apply


Step 6. go to elastic-search\aws-es-devops\terraform\dev\logstash_dev\ (make the changes in main.tf as mentioned in note)

terraform init
terraform validate
terraform apply

Step 7. go to elastic-search\aws-es-devops\terraform\dev\grafana_dev\ (make the changes in main.tf as mentioned in note)

terraform init
terraform validate
terraform apply

Step 8. go to elastic-search\aws-es-devops\terraform\dev\promethius_dev\ (make the changes in main.tf as mentioned in note)

terraform init
terraform validate
terraform apply

Step 9. go to elastic-search\aws-es-devops\terraform\dev\glitchtip_dev\ (make the changes in main.tf as mentioned in note)

terraform init
terraform validate
terraform apply


NOTE 2: If you wanna delete and re-deploy any specific service then you should try to ensure 
that the ALB listners , target groups , log groups and cluster are deleted via terraform destroy
or manually. If you get the error Entity already exists then feel free to delete that Entity