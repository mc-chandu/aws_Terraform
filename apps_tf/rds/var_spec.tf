/**********
Specifications
**********/

variable "specrds_rds" {
  default = {
    name                 = "" # rds instance name 
    class                = "db.t2.medium"
    engine               = "sqlserver-ex"
    engine_version       = "15.00.4073.23.v1"
    major_engine_version = "15.00"
    family               = "sqlserver-ex-15.0"
    user                 = "master"
    pass                 = "useonceandchange"
    backup_retention     = 0                     # Integer for number of days
    maint_window         = "sat:09:05-sat:10:05" # Time span in UTC> ddd:HH:MM-ddd:HH:MM
    allocated_storage    = 20
    max_allocated_storage = 100
    storage_type         = "gp2"
    encrypt              = false
  }
}
