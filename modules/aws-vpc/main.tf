# Creating VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true


  tags = {
    Name = var.vpc-name
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw-name
  }

  depends_on = [ aws_vpc.vpc ]
}

# Creating Public Subnet 1 
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-cidr1
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name = var.public-subnet1
  }

  depends_on = [ aws_internet_gateway.igw ]
}

# Creating Public Subnet 2 
resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-cidr2
  availability_zone       = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name = var.public-subnet2
  }

  depends_on = [ aws_subnet.public-subnet1 ]
}

# Creating WEB Subnet 1 
resource "aws_subnet" "web-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web-cidr1
  availability_zone       = var.az_1
  #map_public_ip_on_launch = true

  tags = {
    Name = var.web-subnet1
  }

  depends_on = [ aws_internet_gateway.igw ]
}

# Creating WEB Subnet 2 
resource "aws_subnet" "web-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web-cidr2
  availability_zone       = var.az_2
  #map_public_ip_on_launch = true

  tags = {
    Name = var.web-subnet2
  }

  depends_on = [ aws_subnet.web-subnet1 ]
}

# Creating APP Subnet 1 
resource "aws_subnet" "app-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.app-cidr1
  availability_zone       = var.az_1
  #map_public_ip_on_launch = true

  tags = {
    Name = var.app-subnet1
  }

  depends_on = [ aws_internet_gateway.igw ]
}

# Creating APP Subnet 2 
resource "aws_subnet" "app-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.app-cidr2
  availability_zone       = var.az_2
  #map_public_ip_on_launch = true

  tags = {
    Name = var.app-subnet2
  }

  depends_on = [ aws_subnet.app-subnet1 ]
}

# Creating Private Subnet 1 for RDS Instance
resource "aws_subnet" "db-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db-cidr1
  availability_zone       = var.az_1

  tags = {
    Name = var.db-subnet1
  }

  depends_on = [ aws_subnet.public-subnet2 ] ##
}

# Creating Private Subnet 2 for RDS Instance
resource "aws_subnet" "db-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db-cidr2
  availability_zone       = var.az_2

  tags = {
    Name = var.db-subnet2
  }

  depends_on = [ aws_subnet.db-subnet1 ]
}

# Creating Elastic IP for NAT Gateway 1
resource "aws_eip" "eip1" {
  domain = "vpc"

  tags = {
    Name = var.eip-name1
  }

  depends_on = [ aws_subnet.web-subnet2 ]
}

# Creating Elastic IP for NAT Gateway 2
resource "aws_eip" "eip2" {
  domain = "vpc"

  tags = {
    Name = var.eip-name2
  }

  depends_on = [ aws_eip.eip1 ]
}

# Creating NAT Gateway 1
resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public-subnet1.id

  tags = {
    Name = var.ngw-name1
  }

  depends_on = [ aws_eip.eip2 ]
}

# Creating NAT Gateway 2
resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public-subnet2.id

  tags = {
    Name = var.ngw-name2
  }

  depends_on = [ aws_nat_gateway.ngw1 ]
}

# Creating Public Route table 1
resource "aws_route_table" "public-rt1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public-rt-name1
  }

  # depends_on = [ aws_nat_gateway.ngw2 ]
  depends_on = [ aws_nat_gateway.ngw1 ]
}


# Associating the Public Route table Public Subnet
resource "aws_route_table_association" "public-rt-association1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-rt1.id

  depends_on = [ aws_route_table.public-rt1 ]
}

resource "aws_route_table_association" "public-rt-association2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public-rt1.id

  depends_on = [ aws_route_table.public-rt1 ]
}

# Creating Public Route table 2 
# resource "aws_route_table" "public-rt2" {
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = var.public-rt-name2
#   }
  
#   depends_on = [ aws_route_table_association.public-rt-association1 ]
# }

# # Associating the Public Route table 2 Public Subnet 2
# resource "aws_route_table_association" "public-rt-association2" {
#   subnet_id      = aws_subnet.public-subnet2.id
#   route_table_id = aws_route_table.public-rt2.id

#   depends_on = [ aws_route_table.public-rt1 ]
# }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Creating Private Route table 1
resource "aws_route_table" "private-rt1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw1.id
  }

  tags = {
    Name = var.private-rt-name1
  }

  depends_on = [ aws_route_table_association.public-rt-association2 ]
}

# Associating the Private Route table 1 Private Subnet 1
resource "aws_route_table_association" "private-rt-association1" {
  subnet_id      = aws_subnet.web-subnet1.id
  route_table_id = aws_route_table.private-rt1.id

  depends_on = [ aws_route_table.private-rt1 ]
}

resource "aws_route_table_association" "private-rt-association3" {
  subnet_id      = aws_subnet.app-subnet1.id
  route_table_id = aws_route_table.private-rt1.id

  depends_on = [ aws_route_table.private-rt1 ]
}


# Creating Private Route table 2 
resource "aws_route_table" "private-rt2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw2.id
  }

  tags = {
    Name = var.private-rt-name2
  }

  depends_on = [ aws_route_table_association.private-rt-association1 ]
}

# Associating the Private Route table 2 Private Subnet 2
resource "aws_route_table_association" "private-rt-association2" {
  subnet_id      = aws_subnet.web-subnet2.id
  route_table_id = aws_route_table.private-rt2.id

  depends_on = [ aws_route_table.private-rt2 ]
}

resource "aws_route_table_association" "private-rt-association4" {
  subnet_id      = aws_subnet.app-subnet2.id
  route_table_id = aws_route_table.private-rt2.id

  depends_on = [ aws_route_table.private-rt2 ]
}


# # Creating Private Route table 1
# resource "aws_route_table" "private-rt3" {
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.ngw1.id
#   }

#   tags = {
#     Name = var.private-rt-name3
#   }

#   depends_on = [ aws_route_table_association.public-rt-association2 ]
# }

# # Associating the Private Route table 1 Private Subnet 1
# resource "aws_route_table_association" "private-rt-association3" {
#   subnet_id      = aws_subnet.app-subnet1.id
#   route_table_id = aws_route_table.private-rt3.id

#   depends_on = [ aws_route_table.private-rt3 ]
# }


# # Creating Private Route table 2 
# resource "aws_route_table" "private-rt4" {
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.ngw2.id
#   }

#   tags = {
#     Name = var.private-rt-name4
#   }

#   depends_on = [ aws_route_table_association.private-rt-association3 ]
# }

# # Associating the Private Route table 2 Private Subnet 2
# resource "aws_route_table_association" "private-rt-association4" {
#   subnet_id      = aws_subnet.app-subnet2.id
#   route_table_id = aws_route_table.private-rt4.id

#   depends_on = [ aws_route_table.private-rt4 ]
# }

