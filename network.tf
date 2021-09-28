resource "aws_default_subnet" "default_az1_subnet" {
  availability_zone = data.aws_availability_zones.available_zone.names[0]
}
resource "aws_default_subnet" "default_az2_subnet" {
  availability_zone = data.aws_availability_zones.available_zone.names[1]
}

resource "aws_security_group" "http_https_ssh_sec_group" {
  name = "${var.project_name}-allow-http-https-ssh-from-0"
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
    cidr_blocks = [ "0.0.0.0/0" ]
#    cidr_blocks = [ var.ip_for_ssh ]
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
    Name = "${var.project_name}-allow-http-https-ssh-from-0"
  }
}