output "Available-zone" {
  value = data.aws_availability_zones.available_zone.names
}
output "VPC-id" {
  value = aws_default_subnet.default_az1_subnet.vpc_id
}
output "Subnet-az1" {
  value = aws_default_subnet.default_az1_subnet.id
}
output "Subnet-az2" {
  value = aws_default_subnet.default_az2_subnet.id
}
output "Security-group" {
  value = aws_security_group.http_https_ssh_sec_group.id
}
output "DNS-name" {
  value = aws_alb.lb_app_for_autoscaling_webservers_group.dns_name
}