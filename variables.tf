#project is mandatory in project. user should give...in project
variable "project" {
    type = string # actually, this ll be used in project, as per the users choice and must and should, project should be given in module details.
}

#environment is mandatory in project. user should give...in project
variable "environment" {
    type = string # actually, this ll be used in project, as per the users choice and must and should, [environment] should be given in module details.
}

#cidr_block is mandatory in project., can give what users want in list....
variable "cidr_block" {
    default = "10.0.0.0/16"
}

#public_subnet_cidr details its mandatory
variable "public_subnet_cidr" {
    type = list(string)
}

#private_subnet_cidr details its mandatory
variable "private_subnet_cidr" {
    type = list(string)

}

#private_subnet_cidr details its mandatory
variable "database_subnet_cidr" {
    type = list(string)
    
}
# In module, we are giving like, user can also give their own tags like that we creating variable now.

variable "vpc_tags" {
    type = map(string) # only  type = map(string)  if this given, then it becomes mandatory
    default = {} # if this default = {} , also given, then it becomes users choice....
    
}

#Internet gateway Tags as per users choice below...

variable "igw_tags"{
    type = map(string)  # only  type = map(string)  if this given, then it becomes mandatory
    default = {} # if this default = {} , also given, then it becomes users choice....
}

#Public subnet tags Tags as per users choice below...
variable "public_subnet_tags" {
    type = map(string)  # only  type = map(string)  if this given, then it becomes mandatory
    default = {} # if this default = {} , also given, then it becomes users choice....
}

#Private subnet tags Tags as per users choice below...
variable "private_subnet_tags" {
    type = map(string)  # only  type = map(string)  if this given, then it becomes mandatory
    default = {} # if this default = {} , also given, then it becomes users choice....
}

#database subnet tags Tags as per users choice below...
variable "database_subnet_tags" {
    type = map(string)  # only  type = map(string)  if this given, then it becomes mandatory
    default = {} # if this default = {} , also given, then it becomes users choice....
}

# Elastic ip tags as per users choice below...
variable "eip_tags" {

    type = map(string)  # only  type = map(string)  if this given, then it becomes mandatory
    default = {} # if this default = {} , also given, then it becomes users choice....    
}

#  NAT Gateway tags as per users choice below...
variable "nat_gateway_tags" {
    type = map(string)  # only  type = map(string)  if this given, then it becomes mandatory
    default = {} # if this default = {} , also given, then it becomes users choice....      
}

# public_route_table_tags as per users choice below...
variable "public_route_table_tags" {
    type = map(string)  # only  type = map(string)  if this given, then it becomes mandatory
    default = {} # if this default = {} , also given, then it becomes users choice....      
}

# private_route_table_tags as per users choice below...
variable "private_route_table_tags" {
    type = map(string)  # only  type = map(string)  if this given, then it becomes mandatory
    default = {} # if this default = {} , also given, then it becomes users choice....      
}

# database_route_table_tags as per users choice below...
variable "database_route_table_tags" {
    type = map(string)  # only  type = map(string)  if this given, then it becomes mandatory
    default = {} # if this default = {} , also given, then it becomes users choice....      
}

#peering one vpc to another vpc if required
variable "is_peering_required"{
    default = false
}

# vpc peering tags as per users choice below...
variable "vpc_peering_tags" {
    type = map(string)  # only  type = map(string)  if this given, then it becomes mandatory
    default = {} # if this default = {} , also given, then it becomes users choice....      
}
