provider "aws" {
  region = "us-east-1"  # Adjust the region as necessary
}

# Elastic Beanstalk Application (No changes needed here)
resource "aws_elastic_beanstalk_application" "python_app" {
  name        = "python-app"
  description = "Python application for Elastic Beanstalk"
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "python_env" {
  name                = "python-env"
  application         = aws_elastic_beanstalk_application.python_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.8 running Python 3.8"  # Adjust Python version as needed

  # Use the default version for the application
  appversion {
    version_label = "latest"  # AWS Elastic Beanstalk's default version
  }

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
    value     = "application.py"  # Path to your main Python app (adjust if needed)
  }

  tags = {
    Name = "python-beanstalk-environment"
  }
}

# Output the URL of the Elastic Beanstalk Environment
output "elastic_beanstalk_url" {
  value = aws_elastic_beanstalk_environment.python_env.endpoint_url
}
