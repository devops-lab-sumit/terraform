output "vpc_id" {
    value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
    value = {
        for idx, subnet in aws_subnet.my_public_subnet : idx => subnet.id
    }
}