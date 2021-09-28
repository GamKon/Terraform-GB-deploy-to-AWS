variable "region_project_in" { default = "us-east-1" }
variable "az_project_in" { default = "us-east-1a" }
variable "ip_for_ssh_inbound_connection" { default = "67.69.76.206/32" }
variable "instance_type_webserver" { default = "t2.micro" }

variable "project_name" { default = "Project" }
variable "project_owner" { default = "GamKon" }
variable "project_environment" {default = "Dev"}


variable "tags_common" {
  description = "Common tags for all resources"
  type = map
  default = {
    Owner   = "GamKon"
/*
    Project = "${project_name}"
    Environment = var.project_environment
*/  
  }
}
