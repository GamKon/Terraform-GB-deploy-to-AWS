resource "aws_security_group" "ssh_http_https" {
  name = "allow_ssh_http_https_from_0"
  description = "Firewall for WebServer"
  # vpc_id = aws_vpc..id

  dynamic "ingress" {
      for_each = ["80", "443"]
      content {
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "inbound from internet"
        from_port = ingress.value
        ipv6_cidr_blocks = [ "::/0" ]
        prefix_list_ids = []
        protocol = "tcp"
        security_groups = []
        self = false
        to_port = ingress.value
      }
  }
  ingress {
      cidr_blocks = [ "67.69.76.206/32" ]
      description = "inbound SSH port 22 from my IP"
      from_port = 22
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "tcp"
      security_groups = []
      self = false
      to_port = 22
    }
  
  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Outbound everything"
    from_port = 0
    ipv6_cidr_blocks = [ "::/0" ]
    prefix_list_ids = []
    protocol = "-1"
    security_groups = []
    self = false
    to_port = 0
  } ]
    
  tags = {
    Name = "allow_ssh_http_https"
  }
}