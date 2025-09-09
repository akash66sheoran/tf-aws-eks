#################################
# VPC
#################################
resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

#################################
# Public Subnets
#################################

resource "aws_subnet" "public" {
  for_each = { for idx, az in data.aws_availability_zones.available.names : idx => az }

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, each.key) # assign unique subnet
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.cluster_name}-eks-public-${each.value}"
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#################################
# Private Subnets
#################################

resource "aws_subnet" "private" {
  for_each = { for idx, az in data.aws_availability_zones.available.names : idx => az }

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, each.key + length(data.aws_availability_zones.available.names))
  availability_zone       = each.value
  map_public_ip_on_launch = false

  tags = {
    Name                              = "${var.cluster_name}-eks-private-${each.value}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#################################
# Internet Gateway
#################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

#################################
# Public Route Table
#################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.cluster_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

#################################
# NAT Gateway for Private Subnets
#################################
resource "aws_eip" "nat" {
  tags = {
    Name = "${var.cluster_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = {
    Name = "${var.cluster_name}-natgw"
  }
}

#################################
# Private Route Table
#################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "${var.cluster_name}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}