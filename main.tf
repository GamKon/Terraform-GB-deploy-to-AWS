provider "aws" {
  region = var.region_project_in
}

terraform {
  backend "s3" {
    bucket = "terraform-state-files-gamkon"
    key    = "terraform-gb-deploy-to-aws/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_launch_configuration" "web_srv_launch_conf" {
  name_prefix     = "${var.project_name}-web-srv-"
  image_id        = data.aws_ami.latest_amazon_linux_2_ami.id
  instance_type   = var.instance_type_webserver
  security_groups = [aws_security_group.http_https_ssh_sec_group.id]
  # creates webserver:
  user_data = file(var.bootstrap_script_file)

  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "autoscaling_webservers_group" {
  name                      = "ASG-${aws_launch_configuration.web_srv_launch_conf.name}"
  launch_configuration      = aws_launch_configuration.web_srv_launch_conf.name
  min_size                  = 2
  max_size                  = 2
  min_elb_capacity          = 2
  health_check_type         = "ELB"
  health_check_grace_period = 90
  availability_zones        = [data.aws_availability_zones.available_zone.names[0], data.aws_availability_zones.available_zone.names[1]]
  target_group_arns         = [aws_alb_target_group.tg_for_webservers.arn]

  lifecycle { create_before_destroy = true }

  dynamic "tag" {
    for_each = {
      Name  = "web_as_group"
      Owner = "GamKon"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_alb" "lb_app_for_autoscaling_webservers_group" {
  name               = "${var.project_name}-lb-for-webservers"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.http_https_ssh_sec_group.id]
  subnets            = [aws_default_subnet.default_az1_subnet.id, aws_default_subnet.default_az2_subnet.id]

  /* enable_deletion_protection = true
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  } */
  lifecycle { create_before_destroy = true }

  tags = merge(var.tags_common, { Name = "${var.project_name}-lb-for-webservers" })
}

resource "aws_alb_target_group" "tg_for_webservers" {
  name     = "${var.project_name}-tg-for-webservers"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_subnet.default_az1_subnet.vpc_id
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    interval            = 10
  }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.lb_app_for_autoscaling_webservers_group.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg_for_webservers.arn
  }
}
