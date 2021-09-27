provider "aws" {
  region = var.region_project_in
}


resource "aws_launch_configuration" "as_web_srv_conf" {
  name_prefix   = "web-srv-"
  image_id      = data.aws_ami.Latest_Amazon_Linux_2_AMI.id
  instance_type = "t2.micro"
  security_groups = [ aws_security_group.ssh_http_https.id ]
  #creates webserver
  user_data = file("user_data_Redhat_yum.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_as_group" {
  name                 = "asg-webservers"
  launch_configuration = aws_launch_configuration.as_web_srv_conf.name
  min_size             = 2
  max_size             = 4
  availability_zones   = [ data.aws_availability_zones.available.names[0] ]
#  load_balancers = [ "value" ]

  lifecycle {
    create_before_destroy = true
  }
}
