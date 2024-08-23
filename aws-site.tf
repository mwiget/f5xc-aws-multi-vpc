module "aws" {
  count                     = 1
  source                    = "./site"
  f5xc_cluster_name         = format("%s-aws-mvpc-%d", var.project_prefix, count.index)
  secure_mesh_site_provider = "aws"
  aws_instance_type         = "t3.xlarge"
  aws_ami_name              = var.aws_ami_name

  aws_region                = "us-east-1"
  providers                 = {
    aws                     = aws.us-east-1
  }
  aws_availability_zones    = [ "a", "b", "c"]

  master_node_count         = 4
  worker_node_count         = 0

  ssh_public_key            = var.ssh_public_key
  aws_owner_tag             = var.aws_owner_tag

  aws_vpc_cidr              = "10.0.0.0/16"
  aws_slo_subnets           = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  aws_sli_subnets           = [
    {
      vpc_cidr              = "10.10.0.0/16",
      vpc_subnets           = [ "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24" ]
    },
    {
      vpc_cidr              = "10.11.0.0/16",
      vpc_subnets           = [ "10.11.1.0/24", "10.11.2.0/24", "10.11.3.0/24" ]
    }
  ]
    
  f5xc_tenant               = var.f5xc_tenant
  f5xc_api_url              = var.f5xc_api_url
  f5xc_api_token            = var.f5xc_api_token
}
