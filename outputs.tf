output "vpc_id" {
    value = aws_vpc.main.id

}

#this comes from the module, check in main.tf, then go to that module, more more info, check mainly main.tf then other files in that module...
output "public_subnet_ids" {
    value = aws_subnet.public[*].id # here i am getting 2 subnets, thats y i am using *.id here..
}