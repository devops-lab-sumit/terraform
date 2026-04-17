provider "aws" {
    region = "ap-south-1"

    default_tags{
        tags = {
            Name = "awsResource"
            CostCenter = "12345"
            Environment = "dev" 
        }
    }
}

module "vpc"{
    source = "./modules/vpc"
    vpc_cidr = "10.0.0.0/16"
    public_subnets=["10.0.1.0/24","10.0.3.0/24"]
}

module "s3" {
    source = "./modules/s3"
   
}


