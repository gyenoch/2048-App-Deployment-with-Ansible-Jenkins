# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpc-name
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw-name
  }
}

# Create a Subnet (Public Subnet 1)
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet-name
  }
}

# Create a Subnet (Public Subnet 2)
resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet-name2
  }
}

# # Create a Security Group
# data "aws_security_group" "sg-default" {
#   filter {
#     name   = "tag:Name"
#     values = [var.security-group-name]
#   }
# }

resource "aws_security_group" "sg-default" {
  name        = "Jenkins-Security-Group"
  description = "Open 22,443,465,80,8080,9000,9100,9090,3000"
  vpc_id       = aws_vpc.vpc.id

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443,465,8080,9000,9100,9090,3000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-sg"
  }
}

# Create a Route Table for Subnet 2
resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.rt-name2
  }
}

# Associate Route Table with Subnet 2
resource "aws_route_table_association" "rt-association2" {
  route_table_id = aws_route_table.rt2.id
  subnet_id      = aws_subnet.public-subnet2.id
}

# resource "aws_subnet" "public-subnet2" {
#   vpc_id                  = data.aws_vpc.vpc.id
#   cidr_block              = "10.0.2.0/24"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = var.subnet-name2
#   }
# }

# resource "aws_route_table" "rt2" {
#   vpc_id = data.aws_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = data.aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = var.rt-name2
#   }
# }

# resource "aws_route_table_association" "rt-association2" {
#   route_table_id = aws_route_table.rt2.id
#   subnet_id      = aws_subnet.public-subnet2.id
# }