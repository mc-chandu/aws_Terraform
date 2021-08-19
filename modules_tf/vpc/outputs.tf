# Module Outputs

# VPC

output "vpc_id" {
  depends_on = [ aws_vpc.default ]
  value = aws_vpc.default.id
}

output "vpc_cidr" {
  depends_on = [ aws_vpc.default ]
  value = aws_vpc.default.cidr_block
}

# Security Groups

output "sg_public_http" {
  depends_on = [ aws_security_group.public_http ]
  value = aws_security_group.public_http.id
}

output "sg_public_https" {
  depends_on = [ aws_security_group.public_https ]
  value = aws_security_group.public_https.id
}

output "sg_public_web" {
  depends_on = [ aws_security_group.public_web ]
  value = aws_security_group.public_web.id
}

# Subnets

output "subnet_private" {
  depends_on = [ aws_subnet.private ]
  value = [ aws_subnet.private.*.id ]
}

output "subnet_public" {
  depends_on = [ aws_subnet.public ]
  value = [ aws_subnet.public.*.id ]
}

output "subnet_public_a" {
  depends_on = [ aws_subnet.public ]
  value = aws_subnet.public.0.id
}

output "subnet_public_b" {
  depends_on = [ aws_subnet.public ]
  value = aws_subnet.public.1.id
}

output "subnet_public_c" {
  depends_on = [ aws_subnet.public ]
  value = aws_subnet.public.2.id
}

output "nat_public_ip" {
  depends_on = [ aws_subnet.public ]
  value = [ aws_eip.nat.*.public_ip ]
}

# Route tables

output "rt_main_id" {
  depends_on = [ aws_route_table.main ]
  value      = aws_route_table.main.id
}

output "rt_data_ids" {
  depends_on = [ aws_route_table.data ]
  value      = [ aws_route_table.data.*.id ]
}

output "rt_private_ids" {
  depends_on = [ aws_route_table.private ]
  value      = [ aws_route_table.private.*.id ]
}

output "rt_public_ids" {
  depends_on = [ aws_route_table.public ]
  value      = [ aws_route_table.public.*.id ]
}
