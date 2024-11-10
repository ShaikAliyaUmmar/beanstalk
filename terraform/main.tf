provider "aws" {
  region = "us-east-1" # Change this to your preferred region
}
 
# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "my_python_app" {
  name        = "my-python-app"
  description = "A sample Elastic Beanstalk application running Python"
}
 
# Elastic Beanstalk Application Version
resource "aws_elastic_beanstalk_application_version" "app_version" {
  application = aws_elastic_beanstalk_application.my_python_app.name
  version_label = "v1"
  # AWS S3 bucket containing the sample application provided by AWS
  s3_bucket = "elasticbeanstalk-samples-us-west-2"  # Make sure this matches the provider region
  s3_key    = "python-sample.zip"
}
 
# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "my_python_env" {
  name                = "my-python-env"
  application         = aws_elastic_beanstalk_application.my_python_app.name
  version_label       = aws_elastic_beanstalk_application_version.app_version.version_label
  solution_stack_name = "64bit Amazon Linux 2 v3.4.11 running Python 3.8"  # Use the latest Python platform version
 
  # Environment configuration
  settings {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"  # Specify instance type as required
  }
 
  settings {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
}
