resource "aws_subnet" "public-subnet" {
    vpc_id              = aws_vpc.vpc.vpc_id
    cidr_block          = var.public_subnet.cidr_block
    availability_zone   = var.public_subnet.availability
		map_public_ip_on_launch = true

    tags = {
        "Name"                              = var.public_subnet.name
        "kubernetes.io/role/internal-elb"   = "1"
        "kubernetes.io/cluster/demo"        = "owned"
    }
}

resource "aws_subnet" "private-subnet" {
    vpc_id              = aws_vpc.vpc.vpc_id
    cidr_block          = var.private_subnet.cidr_block
    availability_zone   = var.private_subnet.availability

    tags = {
        "Name"                              = var.private_subnet.name
        "kubernetes.io/role/internal-elb"   = "1"
        "kubernetes.io/cluster/demo"        = "owned"
    }
}