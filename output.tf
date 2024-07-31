output "site" {
  value = {
    aws               = module.aws
  }
  sensitive = true
}

output "ip_address" {
  value = module.aws[*].node.aws[*].ip_address
}
