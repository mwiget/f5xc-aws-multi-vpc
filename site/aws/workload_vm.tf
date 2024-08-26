resource "aws_instance" "workload_vm" {
  count                       = length(var.aws_sli_subnets)
  ami                         = data.aws_ami.latest-ubuntu.id
  instance_type               = "t3.micro"
  user_data_replace_on_change = true
  vpc_security_group_ids      = [
    resource.aws_security_group.allow_sli_traffic[count.index].id
  ]
  subnet_id                   = aws_subnet.sli[count.index].id   # TODO needs fixing for multiple az
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/templates/ubuntu_iperf3.tmpl", {
    ssh_public_key = var.ssh_public_key
  })

  tags = {
    Name    = format("%s-sli-workload-%d%s", var.f5xc_cluster_name, count.index, var.aws_availability_zones[count.index % length(var.aws_availability_zones)])
    Creator = var.aws_owner_tag
  }
}

