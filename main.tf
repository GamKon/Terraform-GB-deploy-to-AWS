provider "aws" {
  region = var.region_project_in
}

data "aws_availability_zones" "available" {}

data "aws_ami" "Latest_Amazon_Linux_2_AMI" {
  owners = [ "amazon" ]
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

