provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = "~> 1.2"
}


data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"
  config = {
    bucket = "terraform-state-aws-es-devops-cloud-wizard"
    key    = "dev-cluster-ecs.tfstate"
    region = "us-east-1"
  }
}



module "ecs" {
  source             =  "../../modules/grafana_mod/ecs"
  vpc_id             = "vpc-0cfd003c32881640e"
  public_subnets     = ["subnet-02c1ec5a5228083ce" , "subnet-038d7e2bf6ebb2494"]
  private_subnets    = ["subnet-054c838f4be5028e9" , "subnet-03adfa781aa00b3c5"]
  availability_zones = ["us-east-1a" , "us-east-1b" , "us-east-1c"]
  task_definitions   = var.task_definitions
  target_groups      = var.target_groups
  existing_security_group     = "sg-06fec6b25ce87ec6a"

  # Pass the ALB ARN from the ECS module
  alb_arn = data.terraform_remote_state.ecs_cluster.outputs.alb_arn

}

