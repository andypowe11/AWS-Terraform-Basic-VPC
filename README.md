# AWS Terraform Basic VPC

Basic VPC with 1 group of up to 3 public subnets (across availability zones in the same region), 3 groups of up to 3 private subnets (across the same availability zones) and an AWS NET server in one of the public subnets.

Copy the files in 'extras' for a minimal web server deployment within the VPC.

Deploy with:

    terraform plan
    terraform apply
    
Delete everything with:

    terraform destroy
