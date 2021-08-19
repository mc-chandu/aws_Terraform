module "vpc" {
  source   = "../../modules_tf/vpc"
  name     = "vpc"
  loc      = var.loc
  loc_peer = var.loc_peer
  loc_azs  = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  nat_loc_azs = ["ap-south-1a", "ap-south-1b"]
  loc_cidr = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  data_subnets    = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
}
