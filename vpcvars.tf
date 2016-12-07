# Customer name
variable "customer" {
  default = "ap-tf"
}

# AWS region
variable "region" {
  default = "eu-west-1"
}

# VPC CIDR block
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# Number of AZs to be used
variable "az_count" {
  default = "3"
}

# List of one character AZ suffixes
variable "azs" {
  default = {
    "0" = "a"
    "1" = "b"
    "2" = "c"
  }
}

# Name of the public subnet
variable "pubsub_name" {
  default = "dmz"
}

# List of CIDR blocks to be used for the public subnets
variable "pubsub_cidrs" {
  default = {
    "0" = "10.0.0.0/24"
    "1" = "10.0.1.0/24"
    "2" = "10.0.2.0/24"
  }
}

# List of names of the private subnets
variable "prisub_names" {
  default = {
    "0" = "web"
    "1" = "app"
    "2" = "data"
  }
}

# List of CIDR blocks to be used for the first private subnet
variable "prisub_0_cidrs" {
  default = {
    "0" = "10.0.10.0/24"
    "1" = "10.0.11.0/24"
    "2" = "10.0.12.0/24"
  }
}

# List of CIDR blocks to be used for the second private subnet
variable "prisub_1_cidrs" {
  default = {
    "0" = "10.0.20.0/24"
    "1" = "10.0.21.0/24"
    "2" = "10.0.22.0/24"
  }
}

# List of CIDR blocks to be used for the third private subnet
variable "prisub_2_cidrs" {
  default = {
    "0" = "10.0.30.0/24"
    "1" = "10.0.31.0/24"
    "2" = "10.0.32.0/24"
  }
}
