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
