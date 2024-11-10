provider "aws" {
  region = "us-east-1"
}
 
# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "example" {
  name        = "simple-app"
  description = "A simple Elastic Beanstalk application"
}
 
# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "example_env" {
  name                   = "simple-env"
  application            = aws_elastic_beanstalk_application.example.name
  solution_stack_name    = "64bit Amazon Linux 2023 v4.3.0 running Python 3.12"  # Ensure this matches an available stack in us-east-1
  #wait_for_ready_timeout = "20m"
 
  # Environment configuration settings
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
}
