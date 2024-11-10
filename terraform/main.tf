provider "aws" {
  region = "us-east-1"  # Adjust the region as necessary
}

resource "aws_eb_application" "python_app" {
  name = "python-app"
}

resource "aws_eb_application_version" "python_app_version" {
  name        = "v1"
  application = aws_eb_application.python_app.name
  bucket      = aws_s3_bucket.app_bucket.bucket
  key         = "python-app.zip"  # This should be the file uploaded to S3
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "my-python-app-bucket-unique"  # Change this to a unique bucket name
}

resource "aws_eb_environment" "python_env" {
  name                = "python-env"
  application         = aws_eb_application.python_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.8 running Python 3.8"  # Adjust Python version as needed
  version             = aws_eb_application_version.python_app_version.name

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
    value     = "application.py"  # Path to your main Python app
  }

  tags = {
    Name = "python-beanstalk-environment"
  }
}

output "elastic_beanstalk_url" {
  value = aws_eb_environment.python_env.endpoint_url
}
