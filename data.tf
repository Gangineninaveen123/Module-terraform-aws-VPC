# data source aws_availability_zones terraform - to get all the availability zones in that region for ex:- us-east-1a
data "aws_availability_zones" "available" {
  state = "available"
}

output "availability_zones_info"{
    value = data.aws_availability_zones.available # ll get all the details of availability from data top code...
}

# here i am ssking the  default vpc id data
data "aws_vpc" "default" {
  default = true
}
#down side i am getting default vpc id in out put, through above data source.
output "default_vpc_id" {
  value = data.aws_vpc.default
}

# AS SAME, how we have done VPC PEERING IN roboshop-dev vpc[ the default vpc cidr details ], same like that, WE NEED TO ADD OR VPC PEERING in default vpc[Need to add the roboshop-dev cidr details in main route table of default vpc]
# same we need use data source
data "aws_route_table" "main" {
  vpc_id = data.aws_vpc.default.id 
  filter {
    name = "association.main" # Every VPC must have one main route table, Terraform filter finds that one route table, No matter how many route tables exist, only one returns true, so the fileter here means - “Select the route table that is automatically used by the VPC when no custom route table is assigned.”
    values = ["true"]
  }
}