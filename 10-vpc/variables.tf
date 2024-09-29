variable "public_cidr_blocks" {
    type = list
    default = ["10.0.1.0/24","10.0.11.0/24"]
}

variable "private_subnet_cidrs_block" {
    type = list
    default = ["10.0.2.0/24","10.0.35.0/24"]
}

variable "database_subnet_cidr_block" {
    type = list
    default = ["10.0.4.0/24","10.0.44.0/24"]
}

variable "is_peering_required" {
    default = true
}

variable "dest_cidr_block" {
    default = "172.31.0.0/16"
}