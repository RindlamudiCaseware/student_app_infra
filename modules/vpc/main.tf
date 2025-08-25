terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
  }
}

# ---------------------------------------
# VPC CREATION FOR BOTH VPC
# ---------------------------------------
resource "aws_vpc" "two_vpc" {
  for_each             = var.vpc_cidrs
  cidr_block           = each.value
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = each.key
    Environment = var.env[0]
    Project     = var.project_name
  }
}

# ---------------------------------------
# IGW CREATION FOR BOTH VPC
# ---------------------------------------
resource "aws_internet_gateway" "for_both_igw" {
  for_each = aws_vpc.two_vpc

  vpc_id = each.value.id

  tags = {
    Name        = "IGW-${each.key}"
    Environment = var.env[0]
    Project     = var.project_name
  }
}

# ---------------------------------------
# PUBLIC SUBNET CREATION FOR BATION VPC
# ---------------------------------------

resource "aws_subnet" "bastion_pub_sub" {
  vpc_id = aws_vpc.two_vpc["Bastion-VPC"].id

  cidr_block        = var.bastion_pub_sub_cidr
  availability_zone = var.azs[0]

  tags = {
    Name        = "Bastion-Pub-Sub"
    Environment = var.env[0]
    Project     = var.project_name
  }

  depends_on = [aws_vpc.two_vpc]
}

# --------------------------------------------
# PUBLIC SUBNET ROUTE CREATION FOR BATION VPC
# --------------------------------------------

resource "aws_route_table" "bastion_pub_sub_rt" {
  vpc_id = aws_vpc.two_vpc["Bastion-VPC"].id

  route {
    cidr_block = var.all_traffic_internet
    gateway_id = aws_internet_gateway.for_both_igw["Bastion-VPC"].id
  }

  tags = {
    Name        = "Bastion-Pub-Sub-RT"
    Environment = var.env[0]
    Project     = var.project_name
  }

  depends_on = [
    aws_vpc.two_vpc,
    aws_subnet.bastion_pub_sub
  ]
}

# ---------------------------------------------------------
# PUBLIC SUBNET ROUTE ASSOCIATION CREATION FOR BATION VPC
# ---------------------------------------------------------

resource "aws_route_table_association" "bastion_pub_sub_rt_associ" {
  subnet_id      = aws_subnet.bastion_pub_sub.id
  route_table_id = aws_route_table.bastion_pub_sub_rt.id

  depends_on = [
    aws_vpc.two_vpc,
    aws_internet_gateway.for_both_igw
  ]
}

# ---------------------------------------
# PUBLIC SUBNET CREATION FOR MAIN VPC
# ---------------------------------------

resource "aws_subnet" "main_pub_sub" {
  vpc_id = aws_vpc.two_vpc["Main-VPC"].id

  cidr_block        = var.main_sub_cidr["pub_cidr"]
  availability_zone = var.azs[0]

  tags = {
    Name        = "Main-Pub-Sub"
    Environment = var.env[0]
    Project     = var.project_name
  }
}

# ------------------------------------------------
# PUBLIC SUBNET ROUTE TABLE CREATION FOR MAIN VPC
# ------------------------------------------------

resource "aws_route_table" "main_pub_sub_rt" {
  vpc_id = aws_vpc.two_vpc["Main-VPC"].id

  route {
    cidr_block = var.all_traffic_internet
    gateway_id = aws_internet_gateway.for_both_igw["Main-VPC"].id
  }

  tags = {
    Name        = "Main-Pub-Sub-RT"
    Environment = var.env[0]
    Project     = var.project_name
  }
}

# ------------------------------------------------------------
# PUBLIC SUBNET ROUTE TABLE ASSOCIATION CREATION FOR MAIN VPC
# ------------------------------------------------------------

resource "aws_route_table_association" "main_pub_sub_rt_associ" {
  subnet_id      = aws_subnet.main_pub_sub.id
  route_table_id = aws_route_table.main_pub_sub_rt.id
}