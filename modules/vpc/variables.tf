variable "vpc_cidr"{
    type = string
}

variable "public_subnets" {
    type =list(string)
}

//public_subnet=["10.0.1.0/24","10.0.2.0/24"]

//variable "private_subnets" {
//    type =list(string)
//}