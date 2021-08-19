resource "aws_vpc" "default" {
  cidr_block = var.loc_cidr
  enable_dns_hostnames = true

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "vpc-eu-prod${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product       = var.loc["product"]
    Application   = var.loc["application"]
    Environment   = var.loc["env"]
    Deployment    = var.loc["deploy"]
  }  
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name          = "IGW ${var.loc["account"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product       = var.loc["product"]
    Application   = var.loc["application"]
    Environment   = var.loc["env"]
    Deployment    = var.loc["deploy"]
  }
}

/***
NATS
***/

resource "aws_nat_gateway" "nat" {
  count         = length(var.nat_loc_azs)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name        = "NAT-Z${count.index} for ${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product       = var.loc["product"]
    Application   = var.loc["application"]
    Environment   = var.loc["env"]
    Deployment    = var.loc["deploy"]
  }
}

resource "aws_eip" "nat" {
  count = length(var.loc_azs)
  vpc   = true
  
  tags = {
    Name        = "EIP:NAT-Z${count.index} for ${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product       = var.loc["product"]
    Application   = var.loc["application"]
    Environment   = var.loc["env"]
    Deployment    = var.loc["deploy"]
  }
}

/***
Route tables
***/
## Main Route table for the VPC

resource "aws_route_table" "main" {
  vpc_id           = aws_vpc.default.id

  tags = {
    Name        = "RT: Main VPC ${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product      = var.loc["product"]
    Application  = var.loc["application"]
    Environment  = var.loc["env"]
    Deployment   = var.loc["deploy"]
  }
}


resource "aws_route" "main_igw" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
  depends_on             = [ aws_route_table.public ]
}

/***
Route Tables
***/

## Data

resource "aws_route_table" "data" {
  count            = length(var.loc_azs) 
  vpc_id           = aws_vpc.default.id

  tags = {
    Name        = "RT: Data Z${count.index} ${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product       = var.loc["product"]
    Application   = var.loc["application"]
    Environment   = var.loc["env"]
    Deployment    = var.loc["deploy"]
  }
}

resource "aws_route" "data_nat" {
  count                  = length(var.loc_azs) 
  route_table_id         = element(aws_route_table.data.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
  depends_on             = [ aws_route_table.data ]
}

## Private

resource "aws_route_table" "private" {
  count            = length(var.loc_azs) 
  vpc_id           = aws_vpc.default.id

  tags = {
    Name        = "RT: Private Z${count.index} ${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product       = var.loc["product"]
    Application   = var.loc["application"]
    Environment   = var.loc["env"]
    Deployment    = var.loc["deploy"]
  }
}

resource "aws_route" "private_nat" {
  count                  = length(var.loc_azs) 
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
  depends_on             = [ aws_route_table.private ]
}

## Public

resource "aws_route_table" "public" {
  count            = length(var.loc_azs)
  vpc_id           = aws_vpc.default.id

  tags = {
    Name        = "RT: Public Z${count.index} ${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product       = var.loc["product"]
    Application   = var.loc["application"]
    Environment   = var.loc["env"]
    Deployment    = var.loc["deploy"]
  }
}

resource "aws_route" "public_igw" {
  count                  = length(var.loc_azs) 
  route_table_id         = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
  depends_on             = [ aws_route_table.public ]
}

# Route Table Associations

## Main Route Table

# Main
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.default.id
  route_table_id = aws_route_table.main.id
}

# Data Route Table Associations
resource "aws_route_table_association" "data" {
  count          = length(var.loc_azs)
  subnet_id      = element(aws_subnet.data.*.id, count.index)
  route_table_id = element(aws_route_table.data.*.id, count.index)
}


# Private Route Table Associations
resource "aws_route_table_association" "private" {
  count          = length(var.loc_azs)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
  count          = length(var.loc_azs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}


/***
Subnet Section Summary:
** Private
** Public
***/

# Date

resource "aws_subnet" "data" {
  count             = length(var.loc_azs)
  vpc_id            = aws_vpc.default.id
  availability_zone = var.loc_azs[count.index]
  cidr_block        = var.data_subnets[count.index]

  tags = {
    Name        = "EU: Data Z${count.index} ${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product       = var.loc["product"]
    Application   = var.loc["application"]
    Environment   = var.loc["env"]
    Deployment    = var.loc["deploy"]
  }
}


# Private

resource "aws_subnet" "private" {
  count             = length(var.loc_azs)
  vpc_id            = aws_vpc.default.id
  availability_zone = var.loc_azs[count.index]
  cidr_block        = var.private_subnets[count.index]

  tags = {
    Name        = "SN: Private Z${count.index} ${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product       = var.loc["product"]
    Application   = var.loc["application"]
    Environment   = var.loc["env"]
    Deployment    = var.loc["deploy"]
  }
}

# Public

resource "aws_subnet" "public" {
  count             = length(var.loc_azs)
  vpc_id            = aws_vpc.default.id
  availability_zone = var.loc_azs[count.index]
  cidr_block        = var.public_subnets[count.index]

  tags = {
    Name        = "SN: Public Z${count.index} ${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product       = var.loc["product"]
    Application   = var.loc["application"]
    Environment   = var.loc["env"]
    Deployment    = var.loc["deploy"]
  }
}

/***
Security Groups:

Purpose: Primary Security Groups used in all Commsuite VPC
***/

## public https (port 80) 

resource "aws_security_group" "public_http" {
  name        = "public_http"
  description = "Public HTTP Access"
  vpc_id      = aws_vpc.default.id
  
  tags = {
    Name        = "sg-public-http-${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product       = var.loc["product"]
    Application   = var.loc["application"]
    Environment   = var.loc["env"]
    Deployment    = var.loc["deploy"]
  }
}

resource "aws_security_group_rule" "public_http_ingress" {
  description     = "Public HTTP access for ${var.loc["id"]}"
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "TCP"
  cidr_blocks     = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.public_http.id
}

resource "aws_security_group_rule" "public_http_egress" {
  description       = "General Egress"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.public_http.id
}

## public https (port 443)

resource "aws_security_group" "public_https" {
  name        = "public_https"
  description = "Public HTTPS Access for ${var.loc["id"]}"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name        = "sg-public-https-${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product      = var.loc["product"]
    Application  = var.loc["application"]
    Environment  = var.loc["env"]
    Deployment   = var.loc["deploy"]
  }
}

resource "aws_security_group_rule" "public_https_ingress" {
  description       = "Public HTTPS access for ${var.loc["id"]}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.public_https.id
}

resource "aws_security_group_rule" "public_https_egress" {
  description       = "General Egress"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.public_https.id
}

# public web accessa (port 80 and 443)

resource "aws_security_group" "public_web" {
  name        = "public_web"
  description = "Public Web Access for ${var.loc["id"]}"
  vpc_id      = aws_vpc.default.id

  tags = {
    Name        = "sg-public-web-${var.loc["id"]}" #use join function to create the name 
    Expire      = var.loc["expire"]
    # Contact Information
    Owner         = var.loc["owner"]
    SME           = var.loc["sme"]
    Documentation = var.loc["url"]
    # Categorization
    Product      = var.loc["product"]
    Application  = var.loc["application"]
    Environment  = var.loc["env"]
    Deployment   = var.loc["deploy"]
  }
}

resource "aws_security_group_rule" "public_web_ingress_http" {
  description       = "Public HTTP access for ${var.loc["id"]}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.public_web.id
}

resource "aws_security_group_rule" "public_web_ingress_https" {
  description       = "Public HTTPS access for ${var.loc["id"]}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.public_web.id
}

resource "aws_security_group_rule" "public_web_egress" {
  description       = "General Egress"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.public_web.id
}
