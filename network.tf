resource "aws_security_group" "ssh_http_https" {
  name = "allow_ssh_http_https_from_0"
  description = "Firewall for WebServer"
  # vpc_id = aws_vpc..id
  ingress = [ 
    {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "inbound SSH port 22"
      from_port = 22
      ipv6_cidr_blocks = [ "::/0" ]
      prefix_list_ids = []
      protocol = "tcp"
      security_groups = []
      self = false
      to_port = 22
    },
    {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "inbound HTTP port 80"
      from_port = 80
      ipv6_cidr_blocks = [ "::/0" ]
      prefix_list_ids = []
      protocol = "tcp"
      security_groups = []
      self = false
      to_port = 80
    },
    {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "inbound HTTPs port 443"
      from_port = 443
      ipv6_cidr_blocks = [ "::/0" ]
      prefix_list_ids = []
      protocol = "tcp"
      security_groups = []
      self = false
      to_port = 443
    },
  ]  
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