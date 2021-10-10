variable "region_project_in" { default = "us-east-1" }
variable "az_project_in" { default = "us-east-1a" }
variable "ip_for_ssh_inbound_connection" { default = "0.0.0.0/0" }
variable "ports_to_open" { default = ["80", "443", "8080"] }
variable "instance_type_webserver" { default = "t2.micro" }
variable "project_name" { default = "Project" }
variable "project_owner" { default = "GamKon" }
variable "project_environment" { default = "Dev" }
variable "bootstrap_script_file" { default = "user_data_redhat_yum.sh" }
variable "tfstate_s3_bucket" { default = "terraform-state-files-gamkon" }
variable "tags_common" {
  description = "Common tags for all resources"
  type        = map(any)
  default = {
    Owner = "GamKon"
    /*
    Project = "${project_name}"
    Environment = var.project_environment
*/
  }
}
