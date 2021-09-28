provider "aws" {
  region = var.region_project_in
}

resource "aws_launch_configuration" "launch_conf_webserver" {
  name_prefix     = "web-srv-"
  image_id        = data.aws_ami.Latest_Amazon_Linux_2_AMI.id
  instance_type   = var.instance_type_webserver
  security_groups = [ aws_security_group.ssh_http_https.id ]
  # creates webserver:
  user_data       = file("user_data_Redhat_yum.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_AS_group" {
  name                      = "ASG-${aws_launch_configuration.launch_conf_webserver.name}"
  launch_configuration      = aws_launch_configuration.launch_conf_webserver.name
  min_size                  = 2
  max_size                  = 2
  min_elb_capacity          = 2
  health_check_type         = "ELB"
  health_check_grace_period = 90
  availability_zones        = [ data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1] ]
  target_group_arns         = [ aws_alb_target_group.target_group_HTTP.arn ]

  lifecycle {
    create_before_destroy = true
  }

  dynamic "tag" {
    for_each = {
      Name = "web_AS_group"
      Owner = "GamKon"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
/*tags = [ {
    "key" = "Name"
    value = "WebServer_in_ASG"
    propagate_at_launch = true
  },
  {
    "key" = "Owner"
    value = "GamKon"
    propagate_at_launch = true
  }
  ] */
}




resource "aws_alb" "LB_for_web_AS_group" {
  name               = "LB-for-webservers"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.ssh_http_https.id ]
  subnets            = [ aws_default_subnet.default_az1_subnet.id, aws_default_subnet.default_az2_subnet.id ]
/* enable_deletion_protection = true
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  } */
  tags = {
    Name = "LB_for_web_AS_group"
  }
}



resource "aws_alb_target_group" "target_group_HTTP" {
  name     = "target-group-HTTP-name"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_subnet.default_az1_subnet.vpc_id
  health_check  {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    interval            = 10
  }
}

resource "aws_alb_listener" "front_end_HTTP" {
  load_balancer_arn = aws_alb.LB_for_web_AS_group.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target_group_HTTP.arn
  }
}
