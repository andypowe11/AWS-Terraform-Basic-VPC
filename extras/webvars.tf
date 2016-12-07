# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-0d77397e"
    us-east-1 = "ami-de7ab6b6"
    us-west-1 = "ami-3f75767a"
    us-west-2 = "ami-21f78e11"
  }
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "private_key_path" {
  default = "~/.ssh/id_rsa"
  description = <<DESCRIPTION
Path to the SSH private key to be used for authentication.
Example: ~/.ssh/terraform
DESCRIPTION
}

variable "key_name" {
  default = "ap-default"
  description = "Desired name of AWS key pair"
}

