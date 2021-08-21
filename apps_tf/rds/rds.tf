#
# rds RDS
#
 module "rds_rds" {
  source = "../../modules_tf/rds"

  # Meta Info    
  loc      = var.loc
  loc_tags = var.loc_tags

  ## Initial DB Name
  dbname = var.specrds_rds["dbname"]

  ## RDS Identifier "group_name-node_name" 
  group_name = var.loc["group"]
  node_name  = var.specrds_rds["name"]

  ## Storage Specs
  inst_storage             = var.specrds_rds["storage"]
  inst_storage_type        = var.specrds_rds["storage_type"]
  inst_storage_iops        = var.specrds_rds["iops"]
  inst_storage_encrypt     = var.specrds_rds["encrypt"]
  inst_max_storage         = var.specrds_rds["max_storage"]
  inst_deletion_protection = var.specrds_rds["deletion_protection"]

  ## MSSQL
  inst_engine               = var.specrds_rds["engine"]
  inst_engine_version       = var.specrds_rds["engine_version"]
  inst_major_engine_version = var.specrds_rds["major_engine_version"]
  db_user                   = var.specrds_rds["username"]
  db_pass                   = var.specrds_rds["pass"]

  inst_class           = var.specrds_rds["class"]
  db_retention_period  = var.specrds_rds["backup_rentention"]
  db_pref_maint_window = var.specrds_rds["maint_window"]
  multi_az             = true
  minor_update         = false
 
  security_group     = [] #use data lookups to fetch security groups
  db_parameter_group = aws_db_parameter_group.rds_param_group.id

  subnet = data.aws_subnet.data.*.id
} 

resource "aws_db_instance" "rds" {
  # Name of instance
  identifier = join("-", [var.loc["group"], var.specrds_rds["name"]])

  # Storage Specs
  allocated_storage     = var.specrds_rds["storage"]
  storage_type          = var.specrds_rds["storage_type"]
  iops                  = var.specrds_rds["iops"]
  storage_encrypted     = var.specrds_rds["encrypt"]
  max_allocated_storage = var.specrds_rds["max"]

  #mssql
  engine         = var.specrds_rds["engine"]
  engine_version = var.specrds_rds["engine_version"]
  instance_class = var.specrds_rds["class"]
  username       = var.specrds_rds["user"]
  password       = var.specrds_rds["pass"]

  backup_retention_period = var.specrds_rds["backup_retention"]
  maintenance_window      = var.specrds_rds["maint_window"]
  deletion_protection     = true

  db_subnet_group_name = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [
    data.aws_security_group.communicate-db.id,
    aws_security_group.mysql_access.id,
    data.aws_security_group.west_ed.id,
  ]

  parameter_group_name = aws_db_parameter_group.rds.id
  option_group_name    = aws_db_option_group.rds.id
  monitoring_interval  = 60 # setting it to 0 will disable enhanced monitoring
  monitoring_role_arn  = data.aws_iam_role.rds-monitoring.arn

  multi_az                     = false
  auto_minor_version_upgrade   = false
  copy_tags_to_snapshot        = true
  final_snapshot_identifier    = join("-", [var.specrds_rds["name"], "final"])
  skip_final_snapshot          = false
  performance_insights_enabled = false

  tags = {
    Name          = join("-", [var.loc["group"], var.specrds_rds["name"]])
    CreatedWith   = join(":", ["TF", var.loc["path"]])
    Group         = var.loc["group"]
    Deployment    = var.loc["deploy"]
    Expires       = var.loc["expire"]
    owner         = var.loc["owner"]
    Documentation = var.loc["url"]
    Product       = var.loc["product"]
    Environment   = var.loc["environment"]
    Sitestatus    = var.loc["sitestatus"]
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = join("-", ["sng", var.specrds_rds["name"], var.loc["id"]])
  subnet_ids = data.aws_subnet.data.*.id
}

resource "aws_db_option_group" "rds" {
  name                     = join("-", ["og", var.specrds_rds["name"], var.loc["id"]])
  option_group_description = "${var.loc["group"]}-${var.specrds_rds["name"]} Option Group"
  engine_name              = var.specrds_rds["engine"]
  major_engine_version     = var.specrds_rds["major_engine_version"]
}

resource "aws_db_parameter_group" "rds" {
  name   = join("-", ["pg", var.specrds_rds["name"], var.loc["id"]])
  family = "mssql${var.specrds_rds["major_engine_version"]}"

  # character_set_client = utf8mb4
  parameter {
    name         = "character_set_client"
    value        = "utf8"
    apply_method = "pending-reboot"
  }

  # character_set_connection = utf8mb4
  parameter {
    name         = "character_set_connection"
    value        = "utf8mb4"
    apply_method = "pending-reboot"
  }

  # character_set_database = utf8mb4
  parameter {
    name         = "character_set_database"
    value        = "utf8mb4"
    apply_method = "pending-reboot"
  }

  # character_set_results = utf8mb4
  parameter {
    name         = "character_set_results"
    value        = "utf8mb4"
    apply_method = "pending-reboot"
  }

  # character_set_server = utf8mb4
  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "pending-reboot"
  }

  # collation_server = utf8_general_ci
  parameter {
    name         = "collation_server"
    value        = "utf8mb4_general_ci"
    apply_method = "pending-reboot"
  }

  # skip_name_resolve = 1
  parameter {
    name         = "skip_name_resolve"
    value        = 0
    apply_method = "pending-reboot"
  }

  # back_log = 150
  parameter {
    name         = "back_log"
    value        = 150
    apply_method = "pending-reboot"
  }

  # max_connections = 2000
  parameter {
    name         = "max_connections"
    value        = 2000
    apply_method = "pending-reboot"
  }

  # table_open_cache = 20000
  parameter {
    name         = "table_open_cache"
    value        = 20000
    apply_method = "immediate"
  }

  # max_allowed_packet = 256M
  parameter {
    name         = "max_allowed_packet"
    value        = 1073741824
    apply_method = "pending-reboot"
  }

  # binlog_cache_size = 4M
  parameter {
    name         = "binlog_cache_size"
    value        = 4194304
    apply_method = "pending-reboot"
  }

  # max_heap_table_size = 256M
  parameter {
    name         = "max_heap_table_size"
    value        = 268435456
    apply_method = "pending-reboot"
  }

  # tmp_table_size = 256M
  parameter {
    name         = "tmp_table_size"
    value        = 268435456
    apply_method = "pending-reboot"
  }

  #  
  # thread_cache_size = 16
  parameter {
    name         = "thread_cache_size"
    value        = 16
    apply_method = "pending-reboot"
  }

  #  
  # query_cache_size = 0
  parameter {
    name         = "query_cache_size"
    value        = 0
    apply_method = "pending-reboot"
  }

  # query_cache_type = 0
  parameter {
    name         = "query_cache_type"
    value        = 0
    apply_method = "pending-reboot"
  }

  # query_cache_limit = 2M
  parameter {
    name         = "query_cache_limit"
    value        = 2097152
    apply_method = "pending-reboot"
  }

  #  
  # ft_min_word_len = 4
  parameter {
    name         = "ft_min_word_len"
    value        = 4
    apply_method = "pending-reboot"
  }

  #  
  # binlog_format = mixed
  parameter {
    name         = "binlog_format"
    value        = "mixed"
    apply_method = "pending-reboot"
  }

  # sync_binlog = 1
  parameter {
    name         = "sync_binlog"
    value        = 1
    apply_method = "pending-reboot"
  }

  #  
  # slow_query_log =1
  parameter {
    name         = "slow_query_log"
    value        = 1
    apply_method = "pending-reboot"
  }

  # long_query_time = 5
  parameter {
    name         = "long_query_time"
    value        = 5
    apply_method = "pending-reboot"
  }

  # log_slow_slave_statements = 1
  parameter {
    name         = "log_slow_slave_statements"
    value        = 1
    apply_method = "pending-reboot"
  }

  # innodb_buffer_pool_size = 102G
  parameter {
    name         = "innodb_buffer_pool_size"
    value        = 109521666048
    apply_method = "immediate"
  }

  # innodb_flush_log_at_trx_commit = 1
  parameter {
    name         = "innodb_flush_log_at_trx_commit"
    value        = 1
    apply_method = "pending-reboot"
  }

  # innodb_log_buffer_size = 32M
  parameter {
    name         = "innodb_log_buffer_size"
    value        = 33554432
    apply_method = "pending-reboot"
  }

  # innodb_log_file_size = 1G
  parameter {
    name         = "innodb_log_file_size"
    value        = 1073741274
    apply_method = "pending-reboot"
  }

  # innodb_flush_method = O_DIRECT
  parameter {
    name         = "innodb_flush_method"
    value        = "O_DIRECT"
    apply_method = "pending-reboot"
  }

  # innodb_lock_wait_timeout = 30
  parameter {
    name         = "innodb_lock_wait_timeout"
    value        = 30
    apply_method = "pending-reboot"
  }

  # innodb_io_capacity = 1200
  parameter {
    name         = "innodb_io_capacity"
    value        = 1200
    apply_method = "pending-reboot"
  }

  # innodb_file_per_table = 0
  parameter {
    name         = "innodb_file_per_table"
    value        = 0
    apply_method = "pending-reboot"
  }

  # explicit_defaults_for_timestamp = 0
  parameter {
    name         = "explicit_defaults_for_timestamp"
    value        = 0
    apply_method = "pending-reboot"
  }

  # log_bin_trust_function_creators = 1
  parameter {
    name         = "log_bin_trust_function_creators"
    value        = 1
    apply_method = "pending-reboot"
  }

  # sql_mode = NO_ENGINE_SUBSTITUION
  parameter {
    name         = "sql_mode"
    value        = "no_engine_substitution"
    apply_method = "pending-reboot"
  }

  # log_output      NONE
  parameter {
    name         = "log_output"
    value        = "FILE"
    apply_method = "immediate"
  }

  #time_zone 
  parameter {
    name         = "time_zone"
    value        = "US/pacific"
    apply_method = "immediate"
  }

  #table_definition_cache
  parameter {
    name         = "table_definition_cache"
    value        = 32768
    apply_method = "immediate"
  }

  # local_infile = 0
  parameter {
    name         = "local_infile"
    value        = 0
    apply_method = "immediate"
  }
}
