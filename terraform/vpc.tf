resource "aws_vpc" "vpc" {
  cidr_block = var.vpc.cidr_block

  tags = {
    Name = var.vpc.vpc_name
  }
}