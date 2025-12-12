locals {
    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }

# check slice functionality in google
    availability_zones = slice(data.aws_availability_zones.available.names, 0, 2) # (0,2) means, it ll take, 0th and 1st index, and dont take 2nd index.....
}