# AWS
provider "aws" {
  region = "${var.region}"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  tags {
    Name = "${var.customer}-vpc"
  }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.customer}-igw"
  }
}

# Up to three public subnets
resource "aws_subnet" "public" {
  count = "${var.az_count}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${lookup(var.pubsub_cidrs, count.index)}"
  availability_zone = "${var.region}${lookup(var.azs, count.index)}"
  map_public_ip_on_launch = "true"
  tags {
    Name = "${var.customer}-${var.pubsub_name}-subnet-${lookup(var.azs, count.index)}"
  }
}

# Elastic IP address for the NAT gateway
resource "aws_eip" "nateip" {
  vpc = true
}

# The NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nateip.id}"
  subnet_id = "${aws_subnet.public.0.id}"
  depends_on = ["aws_internet_gateway.igw"]
}

# Three groups of up to three private subnets
# Group 1
resource "aws_subnet" "private0" {
  count = "${var.az_count}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${lookup(var.prisub_0_cidrs, count.index)}"
  availability_zone = "${var.region}${lookup(var.azs, count.index)}"
  map_public_ip_on_launch = "false"
  tags {
    Name = "${var.customer}-${lookup(var.prisub_names, 0)}-subnet-${lookup(var.azs, count.index)}"
  }
}

# Group 2
resource "aws_subnet" "private1" {
  count = "${var.az_count}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${lookup(var.prisub_1_cidrs, count.index)}"
  availability_zone = "${var.region}${lookup(var.azs, count.index)}"
  map_public_ip_on_launch = "false"
  tags {
    Name = "${var.customer}-${lookup(var.prisub_names, 1)}-subnet-${lookup(var.azs, count.index)}"
  }
}

# Group 3
resource "aws_subnet" "private2" {
  count = "${var.az_count}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${lookup(var.prisub_2_cidrs, count.index)}"
  availability_zone = "${var.region}${lookup(var.azs, count.index)}"
  map_public_ip_on_launch = "false"
  tags {
    Name = "${var.customer}-${lookup(var.prisub_names, 2)}-subnet-${lookup(var.azs, count.index)}"
  }
}

# Route table for the public subnets (via the Internet gateway)
resource "aws_route_table" "public_rtb" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "${var.customer}-publicrtb"
  }
}

# Route table for the private subnets (via the NAT gateway)
resource "aws_route_table" "private_rtb" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat.id}"
  }
  tags {
    Name = "${var.customer}-privatertb"
  }
}

# Public route table associations
resource "aws_route_table_association" "public_association" {
  count = "${var.az_count}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_rtb.id}"
}

# Private route table associations
resource "aws_route_table_association" "private_association" {
  count = "${var.az_count}"
  subnet_id = "${element(aws_subnet.private0.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_rtb.id}"
}
