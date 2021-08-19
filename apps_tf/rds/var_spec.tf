/**********
Specifications
**********/

variable "specrds_rds" {
  default = {
    name                 = "" # rds instance name 
    class                = "db.m5.large"
    engine               = "mssql"
    engine_version       = "SQL Server 2019"
    major_engine_version = "5.7"
    family               = "mysql5.7"
    user                 = "master"
    pass                 = "useonceandchange"
    backup_retention     = 7                     # Integer for number of days
    maint_window         = "sat:09:05-sat:10:05" # Time span in UTC> ddd:HH:MM-ddd:HH:MM
    storage              = 1500
    max                  = 3000
    storage_type         = "io1"
    iops                 = 6000
    encrypt              = true
  }
}