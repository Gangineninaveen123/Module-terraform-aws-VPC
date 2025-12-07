# search vpc reasouse in terraform -> google.
# *****Creating VPC **********
#VPC roboshop-dev
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true # its by deafult its false, ll make as true.

  tags = merge(
    var.vpc_tags, # users choice ll be given first preference then common tags, Name ll be given....., this how follows..
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"

    }
  )
}

#******* Creating Internet gateway *************

#search internet gatewqay resourse in terrform -> google

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id  #association with VPC will be done here only...

  tags = merge(
    var.igw_tags,   # users choice ll be given first preference then common tags, Name ll be given....., this how follows..
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"

    }
  )

}


#***** Creating Public subnets ***********

# search aws subnet terraform -> google
resource "aws_subnet" "public" {

  vpc_id     = aws_vpc.main.id  #attching with vpc, this public subnet
  
  count = length(var.public_subnet_cidr) # this info ll comes from the project vpc

  cidr_block = var.public_subnet_cidr[count.index]  # user need to give in project 

  availability_zone = local.availability_zones[count.index] # in this, with the help of slice , we ll get first 2 avaibility zones where( in slice, 0 index is inclusive and last index is exclusive)

  map_public_ip_on_launch = true # For public subnets - all the created ip address in this subnet, we ll give all true only..


  tags = merge(
    var.public_subnet_tags,# users choice ll be given first preference then common tags, Name ll be given....., this how follows..
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-public-${local.availability_zones[count.index]}"

    }
  )
}



# ************* CRewating private subnets ****************
resource "aws_subnet" "private" {

  vpc_id     = aws_vpc.main.id  #attching with vpc, this public subnet
  
  count = length(var.private_subnet_cidr) # this info ll comes from the project vpc

  cidr_block = var.private_subnet_cidr[count.index]  # user need to give in project 

  availability_zone = local.availability_zones[count.index] # in this, with the help of slice , we ll get first 2 avaibility zones where( in slice, 0 index is inclusive and last index is exclusive)


  tags = merge(
    var.private_subnet_tags, # users choice ll be given first preference then common tags, Name ll be given....., this how follows..
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-private-${local.availability_zones[count.index]}"

    }
  )
}

# ************* CRewating private database subnets ****************
resource "aws_subnet" "database" {

  vpc_id     = aws_vpc.main.id  #attching with vpc, this public subnet
  
  count = length(var.database_subnet_cidr) # this info ll comes from the project vpc

  cidr_block = var.database_subnet_cidr[count.index]  # user need to give in project 

  availability_zone = local.availability_zones[count.index] # in this, with the help of slice , we ll get first 2 avaibility zones where( in slice, 0 index is inclusive and last index is exclusive)


  tags = merge(
    var.database_subnet_tags, # users choice ll be given first preference then common tags, Name ll be given....., this how follows..
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-database-${local.availability_zones[count.index]}"

    }
  )
}

#still not attched to instance, now elastic ip is attching to VPC for now.
#Elastic ip ll be created new one.
resource "aws_eip" "nat" {
  #instance = aws_instance.web.id
  domain   = "vpc"

  tags = merge(
    var.eip_tags,
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}"
    }
  )
}

# Creating NAT Gate way
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id # this elastic ip comes from above, and ll attach to NAT Gateway
  subnet_id     = aws_subnet.public[0].id # here in public subnets, 2 subnets ll create, dut to subnet_cidr , so in 1st subnet, we are keeping out Created NAT Gateway.

  tags = merge(
    var.nat_gateway_tags,
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main] # here, some times terraform ll not know, few dependencies, best one is NAT Gateway, connecting to Internet Gateway, and, then it connects to Internet, so this type situatuation, tyerraform don't know, so this type , we ll give dependency, by our own...
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  
  tags = merge(
    var.public_route_table_tags,
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-public-route-table"
    }
  )
}

# Creation of private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  
  tags = merge(
    var.private_route_table_tags,
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-private-route-table"
    }
  )
}

# Creation of database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  
  tags = merge(
    var.database_route_table_tags,
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-database-route-table"
    }
  )
}

#connecting routes to route table -> public route tabkle to IGW
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id #adding route to route table
  destination_cidr_block    = "0.0.0.0/0" # connecting route from public route table to IGW
  gateway_id  = aws_internet_gateway.main.id
}

#connecting routes to route table -> private route table to NAT Gateway and any how NAT Gateway is connecting to IGW from above[public route table to IGW through route]
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id #adding route to route table
  destination_cidr_block    = "0.0.0.0/0" # connecting route from public route table to IGW
  nat_gateway_id = aws_nat_gateway.main.id # connecting route from private route table to NAT Gate way in Public route table.
}

#connecting routes to route table -> database route table to NAT Gateway and any how NAT Gateway is connecting to IGW from above[public route table to IGW through route]
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id #adding route to route table
  destination_cidr_block    = "0.0.0.0/0" # connecting route from public route table to IGW
  nat_gateway_id = aws_nat_gateway.main.id # connecting route from database route table to NAT Gate way in Public route table.
}

# route table association with subnets -> we are keeping route tables in subnets.
#public route table assiciation with public subnet 
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr) # i need to associate 2 times, beacuse
  subnet_id      = aws_subnet.public[count.index].id  # here first, there are 2 subnet ids , which these 2 subnet ids were in whole one public subnet table we can consider,
  route_table_id = aws_route_table.public.id # so here, the subnet id's , as per count value, wether its 0 or 1, it ll associate or ll connect with public route table.
}

# route table association with subnets -> we are keeping route tables in subnets.
#private route table assiciation with private subnet 
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr) # i need to associate 2 times, beacuse
  subnet_id      = aws_subnet.private[count.index].id  # here first, there are 2 subnet ids , which these 2 subnet ids were in whole one private subnet table we can consider,
  route_table_id = aws_route_table.private.id # so here, the subnet id's , as per count value, wether its 0 or 1, it ll associate or ll connect with private route table.
}

# route table association with subnets -> we are keeping route tables in subnets.
#database route table assiciation with database subnet 
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr) # i need to associate 2 times, beacuse
  subnet_id      = aws_subnet.database[count.index].id  # here first, there are 2 subnet ids , which these 2 subnet ids were in whole one public subnet table we can consider,
  route_table_id = aws_route_table.database.id # so here, the subnet id's , as per count value, wether its 0 or 1, it ll associate or ll connect with database route table.
}