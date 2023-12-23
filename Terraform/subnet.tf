# Create Subnet
  resource "aws_subnet" "my_subnet" {
    vpc_id     = aws_vpc.my_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "your_availability_zone"
  
    tags = {
      Name = "s4-arnold-subnet"
    }
  }