resource "aws_vpc" "main_vpc" {
    //cidr_block = "10.0.0.0/16"
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
    Name = "terraform_vpc"
   
    }
}
resource "aws_subnet" "my_public_subnet" {
    for_each = toset(var.public_subnets)
//    for_each = {
  //for idx, cidr in var.public_subnets :
 // idx => cidr
//}

    vpc_id = aws_vpc.main_vpc.id   //Resource refrencing
    cidr_block = each.value
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
    
    tags={
        Name = "public-subnet-${each.value}"
    }

}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main_vpc.id

    tags={
        Name = "main_vpc_igw"
    }
}

resource "aws_route_table" "public_rt"{
    vpc_id = aws_vpc.main_vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags={
        Name = "public_route_table"
    }
}

resource "aws_route_table_association" "public_assoc" {
    for_each = aws_subnet.my_public_subnet
    subnet_id = each.value.id
    //subnet_id = aws_subnet.my_public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "my_private_subnet" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = false

    tags={
        Name ="private-subnet-1a"
    }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}


resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  //for_each = aws_subnet.my_public_subnet
  //subnet_id = each.value.id
  subnet_id     = values(aws_subnet.my_public_subnet)[0].id
  tags = {
    Name = "main-nat-gateway"
    }

}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.my_private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}


