provider "aws" {
  assume_role{
      role_arn = "arn:aws:iam::${var.loc["account"]}:role/OpsAdmin_role"
  }
  profile = "tfdefault"
  region = var.loc["region"]
}