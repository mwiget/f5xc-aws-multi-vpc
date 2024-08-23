resource "aws_vpc" "slo_vpc" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name    = format("%s-slo", var.f5xc_cluster_name)
    Creator = var.aws_owner_tag
  }
}

resource "aws_subnet" "slo" {
  count                   = length(var.aws_availability_zones)
  vpc_id                  = aws_vpc.slo_vpc.id
  cidr_block              = var.aws_slo_subnets[count.index]
  map_public_ip_on_launch = false
  availability_zone       = format("%s%s", var.aws_region, var.aws_availability_zones[count.index % length(var.aws_availability_zones)])
  tags                    = {
    Name    = format("%s-slo-%s", var.aws_vpc_name, var.aws_availability_zones[count.index % length(var.aws_availability_zones)])
    Creator = var.aws_owner_tag
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.slo_vpc.id

  tags = {
    Name = var.aws_vpc_name
    Creator = var.aws_owner_tag
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.slo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = var.aws_vpc_name
    Creator = var.aws_owner_tag
  }
}

resource "aws_route_table_association" "pub_subnet_rt_join" {
 count          = length(var.aws_slo_subnets)
 subnet_id      = element(aws_subnet.slo[*].id, count.index)
 route_table_id = aws_route_table.public_rt.id
}

#resource "aws_route" "bastion" {
#  route_table_id = aws_vpc.slo_vpc.main_route_table_id
#  destination_cidr_block = var.bastion_cidr
#  gateway_id = aws_internet_gateway.gateway.id
#}

resource "aws_route_table" "rt" {
  vpc_id      = aws_vpc.slo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = format("%s", var.aws_vpc_name)
    Creator = var.aws_owner_tag
  } 
} 

#resource "aws_route_table_association" "rta" {
#  for_each                = {for k, v in var.aws_vpc_subnets :  k => v}
#  subnet_id      = aws_subnet.subnet[each.key].id
#  route_table_id = aws_route_table.rt[each.key].id
#} 

resource "aws_security_group" "allow_slo_traffic" {
  name        = "${var.aws_vpc_name}-allow-slo-traffic"
  description = "allow ssh traffic"
  vpc_id      = aws_vpc.slo_vpc.id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = [ var.aws_vpc_cidr ]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = var.aws_vpc_name
    Creator = var.aws_owner_tag
  }
} 
