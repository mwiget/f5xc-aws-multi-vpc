terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.34"
    }
    restapi = {
      source = "Mastercard/restapi"
      version = "1.19.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.56.1"
    }    
  }
}
