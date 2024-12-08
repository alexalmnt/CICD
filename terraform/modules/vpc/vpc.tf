resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpcidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpcname
  }
}

// Create Two Public Subnet 
resource "aws_subnet" "publicsub1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.pub1cidr
  availability_zone       = var.subnet1az
  map_public_ip_on_launch = true
  tags = {
    Name = "pubsubnet1"
  }
}

resource "aws_subnet" "publicsub2" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.pub2cidr
  availability_zone       = var.subnet2az
  map_public_ip_on_launch = true
  tags = {
    Name = "pubsubnet2"
  }
}
// Create IGW
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "terraigw"
  }
}

// Create Route Table 
resource "aws_route_table" "route1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }
  tags = {
    Name = "routetable1"
  }
}

// Subnet Associations For Route Table
resource "aws_route_table_association" "routeass1" {
  subnet_id      = aws_subnet.publicsub1.id
  route_table_id = aws_route_table.route1.id
}

// Subnet Associations For Route Table
resource "aws_route_table_association" "routeass2" {
  subnet_id      = aws_subnet.publicsub2.id
  route_table_id = aws_route_table.route1.id
}