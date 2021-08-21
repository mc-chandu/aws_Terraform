terraform {
  
  backend "s3" {
    bucket   = "prod-eu-tf"
    key    =   "aws-tf/awstf.state"
    region   = "ap-south-1"
    profile  = "tfdefault"
    role_arn = "arn:aws:iam::383895580391:role/OpsAdmin_role"
  }
}