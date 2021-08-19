terraform {
  
  backend "s3" {
    bucket   = "ext0001"
    key    =   "aws-tf/awstf.state"
    region   = "ap-south-1"
    profile  = "tfdefault"
    role_arn = "arn:aws:iam::863662138515:role/OpsAdmin_role"
  }
}