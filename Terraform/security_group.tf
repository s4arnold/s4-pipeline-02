# Create Security Group
  resource "aws_security_group" "my_security_group" {
    name        = "s4-arnold-security-group"
    description = "Security group for my EC2 instance"
  
    vpc_id = aws_vpc.my_vpc.id
  
    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    ingress {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    ingress {
      from_port   = 5050
      to_port     = 5050
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    ingress {
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    tags = {
      Name = "s4-arnold-security-group"
    }
  }