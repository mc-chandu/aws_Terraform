/**********
Output variables
**********/

output "db_address" {
  value = aws_db_instance.db.address
}

output "db_arn" {
  value = aws_db_instance.db.arn
}

output "db_hosted_zone_id" {
  value = aws_db_instance.db.hosted_zone_id
}
output "id" {
  value = aws_db_instance.db.identifier
}