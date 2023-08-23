
resource "aws_launch_configuration" "this" {
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.prodORqa == "prod" ? "t2.large" : var.instance_type
  security_groups = [aws_security_group.ec2.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              echo "Ola, bem vindo a pagineta do Rafael" > index.html
              nohup busybox httpd -f -p ${var.ec2_port} &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "this" {
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.asg.arn]

  min_size = var.prodORqa == "prod" ? 5 : 2
  max_size = var.prodORqa == "prod" ? 10 : 7

  tag {
    key                 = "Name"
    value               = "terraform-asg-cluster"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "ec2" {
  name = var.sg_name

  ingress {
    from_port   = var.ec2_port
    to_port     = var.ec2_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "this" {
  name = var.alb_name

  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "httpd" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }

}

resource "aws_lb_target_group" "asg" {
  name = var.alb_name

  port     = var.ec2_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.httpd.arn

  condition {
    path_pattern {
      values = ["*"]
    }
  }


  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_security_group" "alb" {
  name = var.alb_sg_name

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

