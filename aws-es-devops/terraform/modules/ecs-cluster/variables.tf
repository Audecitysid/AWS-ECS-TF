variable "docker_image_url_es" {
  type = string
}

variable "vpc_id" {
  type = string
  default="vpc-0cfd003c32881640e"
}

variable "subnets" {
  default = ["subnet-02c1ec5a5228083ce", "subnet-038d7e2bf6ebb2494"]
}