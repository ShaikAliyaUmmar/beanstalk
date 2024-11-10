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
  #platform_arn = "arn:aws:elasticbeanstalk:region::platform/Python 3.12 running on 64bit Amazon Linux 2/version"
  solution_stack_name = "64bit Amazon Linux 2 v3.4.10 running Python 3.8"

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
