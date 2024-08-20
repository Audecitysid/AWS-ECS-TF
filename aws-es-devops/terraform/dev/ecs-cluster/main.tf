terraform {
  backend "s3" {
    bucket         = "terraform-state-aws-es-devops-cloud-wizard"
    encrypt        = true
    key            = "dev-cluster-ecs.tfstate"
    region         = "us-east-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "terraform-state-aws-es-devops-cloud-wizard"
    key    = "dev-network.tfstate"
    region = var.region
  }
}

provider "aws" {
  allowed_account_ids = [var.account_id]
  region              = var.region
}





module "ecs-cluster" {
  source = "../../modules/ecs-cluster"

  account_id = var.account_id
  env        = var.env
  project    = var.project
  region     = var.region

  docker_image_url_es = "011528303833.dkr.ecr.us-east-1.amazonaws.com/docker-images-nvir:v1.0"
}
