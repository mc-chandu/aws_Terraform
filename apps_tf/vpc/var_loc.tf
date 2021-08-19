/****
Local Variables
****/

variable "loc" {
  default = {
    name    = "var_loc"  # May or may not be same as deployment
    account = "863662138515"
    region  = "ap-south-1"
    role    = ""    # IAM Role used  to deploy AWS Resources

    # Categorization
    product     = ""
    application = ""
    environment = ""
    deployment  = ""

    # Short Categorization
    prod   = ""
    app    = ""
    env    = ""
    deploy = ""

    # Categorization Hierarchy.
    path = "" 
    id   = "" 

    # Meta Info
    expire = ""                              
    url    = "" 
    sme    = ""    
    owner  = ""                        
  }
}

variable "loc_azs" {
  default = ["a", "b", "c"]
}

variable "nat_loc_azs" {
  default = ["a", "b"]
}

variable "loc_dns" {
  default = {
    pub = ""       
    pri = ""
  }
}

variable "loc_peer" {
  default = {}
}

variable "loc_tags" {
  default = {
    creator   = ""
    requester = ""
  }
}
