resource "aws_default_subnet" "default_az1_subnet" {
  availability_zone = data.aws_availability_zones.available_zone.names[0]
}
resource "aws_default_subnet" "default_az2_subnet" {
  availability_zone = data.aws_availability_zones.available_zone.names[1]
}

resource "aws_security_group" "http_https_ssh_sec_group" {
  name        = "${var.project_name}-allow-http-https-ssh-from-0"
  description = "Firewall for WebServer"
  # vpc_id = aws_vpc..id

  dynamic "ingress" {
    for_each = var.ports_to_open
    content {
      description      = "inbound from internet"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }
  ingress {
    description      = "inbound SSH port 22 from my IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.ip_for_ssh_inbound_connection]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  egress = [{
    description      = "Outbound everything"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]

  tags = {
    Name = "${var.project_name}-allow-http-https-ssh-from-0"
  }
}