resource "aws_route_table" "route" {
  vpc_id = aws_vpc.vpc.id

   route {
        cidr_block = var.route.cidr_block
        gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.route.name
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.route.id
}