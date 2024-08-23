terraform {
  required_providers {
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
