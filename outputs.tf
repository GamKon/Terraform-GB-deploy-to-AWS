output "network_details" {
  value = data.aws_availability_zones.available_zone
}
/*
output "aws_default_subnet-default_az1_subnet" {
  value = aws_default_subnet.default_az1_subnet.vpc_id
}
*/