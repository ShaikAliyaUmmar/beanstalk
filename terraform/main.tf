provider "aws" {
  region = "us-east-1"
}
 
# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "example" {
  name        = "simple-app"
  description = "A simple Elastic Beanstalk application"
}
 
# IAM Role for Elastic Beanstalk EC2 instances
resource "aws_iam_role" "eb_instance_role" {
  name = "aws-elasticbeanstalk-ec2-role"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
 
# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "eb_instance_policy" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}
 
# Create Instance Profile
resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "aws-elasticbeanstalk-ec2-profile"
  role = aws_iam_role.eb_instance_role.name
}
 
# Launch Template for Auto Scaling
resource "aws_launch_template" "eb_launch_template" {
  name_prefix   = "eb-launch-template"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
 
  iam_instance_profile {
    name = aws_iam_instance_profile.eb_instance_profile.name
  }
 
  lifecycle {
    create_before_destroy = true
  }
}
 
# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "example_env" {
  name                = "simple-env"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "provider "aws" {
  region = "us-east-1"
}
 
# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "example" {
  name        = "simple-app"
  description = "A simple Elastic Beanstalk application"
}
 
# IAM Role for Elastic Beanstalk EC2 instances
resource "aws_iam_role" "eb_instance_role" {
  name = "aws-elasticbeanstalk-ec2-role"
 
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
 
# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "eb_instance_policy" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}
 
# Create Instance Profile
resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "aws-elasticbeanstalk-ec2-profile"
  role = aws_iam_role.eb_instance_role.name
}
 
# Launch Template for Auto Scaling
resource "aws_launch_template" "eb_launch_template" {
  name_prefix   = "eb-launch-template"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
 
  iam_instance_profile {
    name = aws_iam_instance_profile.eb_instance_profile.name
  }
 
  lifecycle {
    create_before_destroy = true
  }
}
 
# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "example_env" {
  name                = "simple-env"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.0 running Python 3.12"
  #wait_for_ready_timeout = "20m"
 
  # Use Launch Template instead of Launch Configuration
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "LaunchTemplate"
    value     = aws_launch_template.eb_launch_template.id
  }
}"
  #wait_for_ready_timeout = "20m"
 
  # Use Launch Template instead of Launch Configuration
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "LaunchTemplate"
    value     = aws_launch_template.eb_launch_template.id
  }
}
