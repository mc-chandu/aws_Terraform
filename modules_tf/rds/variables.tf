
/**********
Input variables
**********/
variable "loc" { 
  type = map(string) 
}

variable "loc_tags" {
  type = map(string)
}

variable "security_group" {
  type = list(string)
}

variable "subnet" {
  type = list(string)
}

# General
variable "group_name" {}

variable "dbname" {}
variable "node_name" {}

# DB Group
variable "db_retention_period" {}

variable "db_pref_maint_window" {}

variable "db_user" {}

variable "db_pass" {}

variable "minor_update"{}

variable "db_parameter_group" {}

# Instance
variable "inst_storage" {}

variable "inst_max_storage" {}

variable "inst_storage_type" {}

variable "inst_storage_iops" {}

variable "inst_storage_encrypt" {}

variable "inst_engine_version" {}

variable "inst_major_engine_version" {}

variable "inst_class" {}
variable "multi_az" {}

variable "inst_deletion_protection" {}

variable "inst_engine" {
  default = "mssql"
}