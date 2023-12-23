# Data source to get the latest Ubuntu 22.04 LTS AMI
  data "aws_ami" "latest" {
    most_recent = true
    owners      = ["099720109477"]  # Canonical account ID for Ubuntu AMIs
  
    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-22.04-amd64-server-*"]
    }
  
    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }
  

  }