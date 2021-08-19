/**********
RDS Module
**********/

# Data Lookups

data "template_file" "db_name" {
  template = var.dbname
}

data "template_file" "group_name" {
  template = join("-", [var.group_name, var.node_name])
}

# Role Lookup
data "aws_iam_role" "rds-monitoring" {
  name = "rds-monitoring-role"
}


#
# Resource
#

resource "aws_db_instance" "db" {
  # Name if instance
  identifier                = data.template_file.group_name.rendered

  # Name of initial database
  name                      = data.template_file.db_name.rendered
  allocated_storage         = var.inst_storage
  max_allocated_storage     = var.inst_max_storage
  storage_type              = var.inst_storage_type
  iops                      = var.inst_storage_iops
  deletion_protection       = var.inst_deletion_protection
  storage_encrypted         = var.inst_storage_encrypt
  engine                    = var.inst_engine
  engine_version            = var.inst_engine_version
  instance_class            = var.inst_class
  username                  = var.db_user
  password                  = var.db_pass
  auto_minor_version_upgrade= var.minor_update
  db_subnet_group_name      = aws_db_subnet_group.db.id
  backup_retention_period   = var.db_retention_period
  maintenance_window        = var.db_pref_maint_window
  vpc_security_group_ids    = var.security_group
  parameter_group_name      = var.db_parameter_group
  option_group_name         = aws_db_option_group.db.id
  monitoring_interval       = 10
  monitoring_role_arn       = data.aws_iam_role.rds-monitoring.arn
  multi_az                  = var.multi_az
  final_snapshot_identifier = join("-", [data.template_file.group_name.rendered, "final"])
  copy_tags_to_snapshot     = true
  performance_insights_enabled = true

  tags = {
    Name        = data.template_file.group_name.rendered
    CreatedWith = join(":", ["TF", var.loc["path"]])
    Creator     = var.loc_tags["creator"]
    Requester   = var.loc_tags["requester"]
  }
}

resource "aws_db_subnet_group" "db" {
  name       = join("-", ["sng", var.node_name, var.loc["id"]])
  subnet_ids = var.subnet

  tags = {
    Name        = "${data.template_file.group_name.rendered} subnet group"
    CreatedWith = join(":", ["TF", var.loc["path"]])
    Creator     = var.loc_tags["creator"]
    Requester   = var.loc_tags["requester"]
  }
}

resource "aws_db_option_group" "db" {
  name                     = join("-", ["og", var.node_name, var.loc["id"]])
  option_group_description = "${data.template_file.group_name.rendered} Option Group"
  engine_name              = var.inst_engine
  major_engine_version     = var.inst_major_engine_version
}