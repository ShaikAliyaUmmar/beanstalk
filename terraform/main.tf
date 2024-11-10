provider "aws" {
  region = "us-east-1"
}
 
# IAM Role for Elastic Beanstalk
resource "aws_iam_role" "elastic_beanstalk_role" {
  name               = "aws-elasticbeanstalk-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}
 
resource "aws_iam_instance_profile" "elastic_beanstalk_profile" {
  name = "aws-elasticbeanstalk-ec2-role"
  role = aws_iam_role.elastic_beanstalk_role.name
}
 
# Attach Elastic Beanstalk policy to the role
resource "aws_iam_role_policy_attachment" "elastic_beanstalk_policy" {
  role       = aws_iam_role.elastic_beanstalk_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}
 
# Launch Template with IMDSv1 enabled
resource "aws_launch_template" "beanstalk_template" {
  name          = "beanstalk-template"
  instance_type = "t3.micro"
  iam_instance_profile {
    name = aws_iam_instance_profile.elastic_beanstalk_profile.name
  }
  metadata_options {
    http_tokens = "optional"  # This enables IMDSv1
  }
}
 
# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "my_app" {
  name        = "my-sample-app-1"
  description = "A sample application for Elastic Beanstalk"
}
 
# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "my_env" {
  name                   = "my-sample-env"
  application            = aws_elastic_beanstalk_application.my_app.name
  solution_stack_name    = "64bit Amazon Linux 2023 v4.3.0 running Python 3.11"  # Use an available stack
  wait_for_ready_timeout = "10m"
 
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
 
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.elastic_beanstalk_profile.name
  }
 
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "LaunchTemplate"
    value     = aws_launch_template.beanstalk_template.id
  }
}

has context menu
