output "slo_vpc" {
  value = resource.aws_vpc.slo_vpc
}

output "sli_vpc" {
  value = resource.aws_vpc.sli_vpc
}

output "sm_sli_eni" {
  value = resource.aws_network_interface.sm_sli_eni
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

output "workload_ip_address" {
    value = {
    for node in concat(aws_instance.workload_vm):
      node.private_ip => node.public_ip
  }
}
