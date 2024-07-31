output "slo_vpc" {
  value = resource.aws_vpc.slo_vpc
}

output "sli_vpc" {
  value = resource.aws_vpc.sli_vpc
}

output "security_group" {
  value = {
    slo = resource.aws_security_group.allow_slo_traffic
    sli = resource.aws_security_group.allow_sli_traffic
  }
}

output "nodes" {
  value = {
    master  = aws_instance.master_vm
  }
}

output "ip_address" {
    value = {
    for node in concat(aws_instance.master_vm):
      node.private_ip => node.public_ip
  }
}
