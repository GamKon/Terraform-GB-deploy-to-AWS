region_project_in             = "us-east-1"
az_project_in                 = "us-east-1a"
ip_for_ssh_inbound_connection = "0.0.0.0/0"
instance_type_webserver       = "t2.micro"
tfstate_s3_bucket             = "terraform-state-files-gamkon"
project_name                  = "TF-GB-websrv"
project_owner                 = "GamKon"
project_environment           = "Dev"
/*
tags_common {
    Owner   = ${project_owner}
    Project = ${project_name}
    Environment = ${project_environment}
}
*/