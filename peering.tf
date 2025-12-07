#peering from roboshop-dev vpc to default vpc in same account and same region

resource "aws_vpc_peering_connection" "default" {

# check , whether u want peering is required or not
    count = var.is_peering_required ? 1 : 0  #here 1 means peering requires, 0 means false not required.

    #peer_owner_id = var.peer_owner_id  # if it another account means ll use this varaible
    peer_vpc_id   = data.aws_vpc.default.id #accepter vpc id, which is default vpc here.
    vpc_id        = aws_vpc.main.id # Requester vpc id , ll get here....

    

    accepter {
        allow_remote_vpc_dns_resolution = true
    }

    requester {
        allow_remote_vpc_dns_resolution = true
    }

    auto_accept = true # This enables automatic acceptance for same-account/same-region peering

    tags = merge(
        var.vpc_peering_tags,
        local.common_tags,
        {
            Name = "${var.project}-${var.environment} - default"
        }

    )
}


# for practice purpose , we are adding all the route tables for vpc peerring, between roboshop-dev vpc AND DEFAULT VPC, but in real time projects or production, we will use , what ever need connection of subnets, we ll use that, thats it.
#connecting routes to route table -> creating route from roboshop-dev vpc, route table to default  vpc, public route table in it, which is in the subnet of default vpc.
  
resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0  #here 1 means peering requires, 0 means false not required.
  route_table_id            = aws_route_table.public.id #adding route to route table
  destination_cidr_block    = data.aws_vpc.default.cidr_block # creating route from roboshop-dev vpc, route table to default  vpc, public route table in it, which is in the subnet of default vpc.
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id # we are accessing vpc peering connection once , only, but we have defined count as list, so we are using count.index 
  
}

#connecting routes to route table -> creating route from roboshop-dev vpc, route table to default  vpc, public route table in it, which is in the subnet of default vpc.
  # private route table peering between, roboshop-dev to default vpc
resource "aws_route" "private_peering" {
  count = var.is_peering_required ? 1 : 0  #here 1 means peering requires, 0 means false not required.
  route_table_id            = aws_route_table.private.id #adding route to route table
  destination_cidr_block    = data.aws_vpc.default.cidr_block # creating route from roboshop-dev vpc, route table to default  vpc, public route table in it, which is in the subnet of default vpc.
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id # we are accessing vpc peering connection once , only, but we have defined count as list, so we are using count.index 
  
}

#connecting routes to route table -> creating route from roboshop-dev vpc, route table to default  vpc, public route table in it, which is in the subnet of default vpc.
  # database route table peering between, roboshop-dev to default vpc
resource "aws_route" "database_peering" {
  count = var.is_peering_required ? 1 : 0  #here 1 means peering requires, 0 means false not required.
  route_table_id            = aws_route_table.database.id #adding route to route table
  destination_cidr_block    = data.aws_vpc.default.cidr_block # creating route from roboshop-dev vpc, route table to default  vpc, public route table in it, which is in the subnet of default vpc.
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id # we are accessing vpc peering connection once , only, but we have defined count as list, so we are using count.index 
  
}


# AS SAME, how we have done VPC PEERING IN roboshop-dev vpc[ the default vpc cidr details ], same like that, WE NEED TO ADD OR VPC PEERING in default vpc[Need to add the roboshop-dev cidr details in main route table of default vpc]
# same we need use data source

#connecting routes to route table -> creating route from roboshop-dev vpc, route table to default  vpc, public route table in it, which is in the subnet of default vpc.
  # database route table peering between, roboshop-dev to default vpc
resource "aws_route" "default_peering" {
  count = var.is_peering_required ? 1 : 0  #here 1 means peering requires, 0 means false not required.
  route_table_id            = data.aws_route_table.main.id #adding route to route table
  destination_cidr_block    = var.cidr_block # creating route from default vpc, route table to roboshop-dev  vpc, public/main route table in it, which is in the subnet of roboshop-dev vpc.
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id # we are accessing vpc peering connection once , only, but we have defined count as list, so we are using count.index 
  
}