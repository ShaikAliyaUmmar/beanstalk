provider "aws" {
  region = "us-east-1"  # Adjust the region as necessary
}

# S3 bucket for storing the application version (Make sure the bucket name is unique)
resource "aws_s3_bucket" "app_bucket" {
  bucket = "my-python-app-bucket-unique"  # Change this to a unique bucket name
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "python_app" {
  name        = "python-app"
  description = "Python application for Elastic Beanstalk"
}

# Elastic Beanstalk Application Version
resource "aws_elastic_beanstalk_application_version" "python_app_version" {
  name        = "v1"
  application = aws_elastic_beanstalk_application.python_app.name
  bucket      = aws_s3_bucket.app_bucket.bucket
  key         = "python-app.zip"  # This is the path to the ZIP file containing your application
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "python_env" {
  name                = "python-env"
  application         = aws_elastic_beanstalk_application.python_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.8 running Python 3.8"  # Adjust Python version as needed
  version             = aws_elastic_beanstalk_application_version.python_app_version.name

  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "/"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:container:python"
    name      = "WSGIPath"
    value     = "application.py"  # Path to your main Python app (e.g., application.py)
  }

  tags = {
    Name = "python-beanstalk-environment"
  }
}

# Output the URL of the Elastic Beanstalk Environment
output "elastic_beanstalk_url" {
  value = aws_elastic_beanstalk_environment.python_env.endpoint_url
}
