resource "aws_vpc" "sli_vpc" {
  count                   = length(var.aws_sli_subnets)
  cidr_block           = var.aws_sli_subnets[count.index].vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name    = format("%s-sli-%d", var.f5xc_cluster_name, count.index)
    Creator = var.aws_owner_tag
  }
}

resource "aws_subnet" "sli" {
  count                   = length(var.aws_sli_subnets) * length(var.aws_availability_zones)
  vpc_id                  = element(aws_vpc.sli_vpc[*].id, floor(count.index / length(var.aws_availability_zones)))
  cidr_block              = var.aws_sli_subnets[floor(count.index / length(var.aws_availability_zones))].vpc_subnets[(count.index % length(var.aws_availability_zones))]
  map_public_ip_on_launch = false
  availability_zone       = format("%s%s", var.aws_region, var.aws_availability_zones[count.index % length(var.aws_availability_zones)])
  tags                    = {
    Name    = format("%s-sli-%d%s", var.f5xc_cluster_name, count.index, var.aws_availability_zones[count.index % length(var.aws_availability_zones)])
    Creator = var.aws_owner_tag
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_internet_gateway" "sli_gateway" {
  count  = length(var.aws_sli_subnets)
  vpc_id = aws_vpc.sli_vpc[count.index].id

  tags = {
    Name    = format("%s-sli-%d", var.f5xc_cluster_name, count.index)
    Creator = var.aws_owner_tag
  }
}

resource "aws_route_table" "sli_public_rt" {
  count  = length(var.aws_sli_subnets)
  vpc_id = aws_vpc.sli_vpc[count.index].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sli_gateway[count.index].id
  }

  route {
    cidr_block = "10.0.0.0/8"
    network_interface_id = aws_network_interface.sm_sli_eni[count.index].id # TODO fix for multi az, multi node
  }

  tags = {
    Name    = format("%s-sli-%d", var.f5xc_cluster_name, count.index)
    Creator = var.aws_owner_tag
  }
}

resource "aws_route_table_association" "sli_subnet_route_association" {
  count          = length(var.aws_sli_subnets) * length(var.aws_availability_zones)
  subnet_id      = aws_subnet.sli[count.index].id   # TODO needs fixing for multiple az
  route_table_id = aws_route_table.sli_public_rt[count.index].id # TODO needs fixing for multiple az
}

resource "aws_security_group" "allow_sli_traffic" {
  count       = length(var.aws_sli_subnets)
  name        = "${var.f5xc_cluster_name}-${count.index}-allow-sli-traffic"
  description = "allow all sli traffic"
  vpc_id      = aws_vpc.sli_vpc[count.index].id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = format("%s-sli-%d", var.f5xc_cluster_name, count.index)
    Creator = var.aws_owner_tag
  }
} 
