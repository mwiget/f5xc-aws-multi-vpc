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
