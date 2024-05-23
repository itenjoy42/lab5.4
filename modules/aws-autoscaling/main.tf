
# ap-northeast-1a에 EC2 인스턴스 생성
resource "aws_instance" "web_instance_1" {
  ami           = data.aws_ami.ami.image_id
  instance_type = var.web-instance-type
  subnet_id     = data.aws_subnet.web-subnet1.id
  vpc_security_group_ids = [data.aws_security_group.web-sg.id] 
  user_data              = filebase64("./modules/aws-autoscaling/deploy-for-web.sh")

  iam_instance_profile = aws_iam_instance_profile.EC2SSM_profile.name

  tags = {
    Name = "Web-Instance-1A"
  }
}

# ap-northeast-1c에 EC2 인스턴스 생성
resource "aws_instance" "web_instance_2" {
  ami           = data.aws_ami.ami.image_id
  instance_type = var.web-instance-type
  subnet_id     = data.aws_subnet.web-subnet2.id
  vpc_security_group_ids = [data.aws_security_group.web-sg.id]
  user_data              = filebase64("./modules/aws-autoscaling/deploy-for-web.sh") 

  tags = {
    Name = "Web-Instance-1C"
  }
}

# 각 인스턴스를 타겟 그룹에 등록
resource "aws_lb_target_group_attachment" "web_tg_attachment_1" {
  target_group_arn = data.aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.web_instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_tg_attachment_2" {
  target_group_arn = data.aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.web_instance_2.id
  port             = 80
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Creating Launch template for APP tier AutoScaling Group
resource "aws_launch_template" "APP-LC" {
  name = var.app-launch-template-name
  image_id = data.aws_ami.ami.image_id
  instance_type = var.app-instance-type

  vpc_security_group_ids = [data.aws_security_group.app-sg.id]

  user_data = filebase64("./modules/aws-autoscaling/deploy-for-app.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.EC2SSM_profile.name
  }
}


resource "aws_autoscaling_group" "APP-ASG" {
  name = var.app-asg-name
  vpc_zone_identifier  = [data.aws_subnet.app-subnet1.id, data.aws_subnet.app-subnet2.id] #ASG(Auto Scaling Group)가 적용되는 서브넷을 지정하는 부분
  launch_template {
    id = aws_launch_template.APP-LC.id
    version = aws_launch_template.APP-LC.latest_version
  }
  desired_capacity = 1
  min_size             = 1
  max_size             = 2
  health_check_type    = "EC2"
  health_check_grace_period = 300
  target_group_arns    = [data.aws_lb_target_group.app-tg.arn] #오토스케일링 그룹 내의 EC2 인스턴스에 트래픽을 분산시키기 위해 ALB(Target Group)를 지정하는 부분
  force_delete         = true
  tag {
    key                 = "Name"
    value               = "APP-ASG"
    propagate_at_launch = true
  }
}

resource "aws_iam_instance_profile" "EC2SSM_profile" {
  name = "EC2SSM-sm"
  role = data.aws_iam_role.EC2SSM.name
} 

# resource "aws_autoscaling_policy" "app-custom-cpu-policy" {
#   name                   = "app-custom-cpu-policy"
#   autoscaling_group_name = aws_autoscaling_group.APP-ASG.id
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = 1
#   cooldown               = 60
#   policy_type            = "SimpleScaling"
# }


# resource "aws_cloudwatch_metric_alarm" "app-custom-cpu-alarm" {
#   alarm_name          = "app-custom-cpu-alarm"
#   alarm_description   = "alarm when cpu usage increases"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = "70"

#   dimensions = {
#     "AutoScalingGroupName" : aws_autoscaling_group.APP-ASG.name
#   }
#   actions_enabled = true

#   alarm_actions = [aws_autoscaling_policy.app-custom-cpu-policy.arn]
# }


# resource "aws_autoscaling_policy" "app-custom-cpu-policy-scaledown" {
#   name                   = "app-custom-cpu-policy-scaledown"
#   autoscaling_group_name = aws_autoscaling_group.APP-ASG.id
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = -1
#   cooldown               = 60
#   policy_type            = "SimpleScaling"
# }

# resource "aws_cloudwatch_metric_alarm" "app-custom-cpu-alarm-scaledown" {
#   alarm_name          = "app-custom-cpu-alarm-scaledown"
#   alarm_description   = "alarm when cpu usage decreases"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = "50"

#   dimensions = {
#     "AutoScalingGroupName" : aws_autoscaling_group.APP-ASG.name
#   }
#   actions_enabled = true

#   alarm_actions = [aws_autoscaling_policy.app-custom-cpu-policy-scaledown.arn]
# }