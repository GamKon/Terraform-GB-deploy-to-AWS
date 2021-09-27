output "az_names" {
  value = data.aws_availability_zones.available.names
}
output "Latest_Amazon_linux_ami_id" {
  value = data.aws_ami.Latest_Amazon_Linux_2_AMI.id
}