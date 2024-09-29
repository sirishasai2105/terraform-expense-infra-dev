resource "aws_ssm_parameter" "vpc_id" {
  name  = "/expense/dev/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/expense/dev/public_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.subnet_ids)
}



