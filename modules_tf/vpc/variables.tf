/**********
Infrastructure Input Variables
**********/

variable "name"     { type = string }
variable "loc"      { type = map }
variable "loc_azs"  { type = list }
variable "nat_loc_azs"  { type = list }
variable "loc_cidr" { type = string }
variable "loc_peer" { type = map }
variable "private_subnets" {
  type = list
  default = []
}
variable "public_subnets" {
  type = list
  default = []
}
variable "data_subnets" {
  type = list
  default = []
}
