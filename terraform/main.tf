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
  name                = "simple-env"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.10 running Python 3.8"  # Use an available platform
 
  # Enable the sample application provided by AWS
  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
 
  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "ApplicationName"
    value     = "Sample Application"  # Specifies AWS's default sample application
  }
}
