variable "namespace" {
  type        = string
  default     = ""
  description = "(Required) The env."
}   
variable "vpc_cidr_block" {
  type        = string
  default     = ""
  description = "(Required) The CIDR block for the VPC."
}

variable "vpc_name" {
  type        = string
  default     = ""
  description = "The VPC Name."
}

variable "vpc_tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) A map of tags to assign to the resource."
}

variable "igw_name" {
  type        = string
  default     = ""
  description = "The IGW Name."
}

variable "azs" {
  type        = list(string)
  default     = []
  description = "(Optional) The AZ for the subnet."
}

variable "eip_name" {
  type        = string
  default     = ""
  description = "The EIP Name."
}

variable "natgw_name" {
  type        = string
  default     = ""
  description = "The Nat GW Name."
}

variable "public_subnets" {
  type        = list(string)
  default     = []
  description = "(Required) The CIDR block for the subnet."
}

variable "public_subnets_name" {
  type        = string
  default     = ""
  description = "Public subnet name."
}

variable "private_subnets" {
  type        = list(string)
  default     = []
  description = "(Required) The CIDR block for the subnet."
}

variable "private_subnets_name" {
  type        = string
  default     = ""
  description = "Private subnet name."
}

variable "db_subnets" {
  type        = list(string)
  default     = []
  description = "(Required) The CIDR block for the subnet."
}

variable "db_subnets_name" {
  type        = string
  default     = ""
  description = "DB subnet name."
}


variable "rtb_public_name" {
  type        = string
  default     = ""
  description = "Public route table name."
}

variable "rtb_private_name" {
  type        = string
  default     = ""
  description = "Private route table name."
}

variable "single_nat_gateway" {
  type        = bool
  default     = false
  description = "Single NAT Gateway."
}

variable "public-key"{
    default = "public.pub"
}