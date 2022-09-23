variable "region" {
  type    = string
  default = "westeurope"
}

variable "region_short" {
  type    = string
  default = "euw"
}

variable "service_principal_id" {
  type    = string
  default = ""
}

variable "my_public_ip" {
  type    = string
  default = ""
}

variable "frontdoor_fqdn" {
  type    = list(string)
  default = []
}