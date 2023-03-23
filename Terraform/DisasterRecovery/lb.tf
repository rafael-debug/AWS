resource "aws_lb_target_group" "this" {
  name     = "appTG"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  #target_type = aws_instance.ec2.id
}

resource "aws_lb" "lb" {
  name               = "appLBOregon"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-LoadBalancerSG.id]

  subnet_mapping {
    subnet_id = aws_subnet.subnet1.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.subnet2.id
  }
}

resource "aws_lb_listener" "front_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.ec2.id
  
  depends_on = [aws_instance.ec2]
}