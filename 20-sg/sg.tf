module "mysql_security_group" {
    source =  "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    # sg_tags = "mysql"
    sg_tags = var.mysql_sg_tags
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "backend_security_group" {
    source =  "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    # sg_tags = "backend"
    sg_tags = var.backend_sg_tags
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "frontend_security_group" {
    source =  "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    # sg_tags = "backend"
    sg_tags = var.database_sg_tags
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "bastion_security_group" {
    source =  "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    # sg_tags = "mysql"
    sg_tags = var.bastion_sg_tags
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

module "ansible_security_group" {
    source =  "../../terraform-aws-security-group"
    project_name = var.project_name
    environment = var.environment
    # sg_tags = "mysql"
    sg_tags = var.ansible_sg_tags
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_security_group_rule" "mysql_from_backend" {
  type = "ingress"
  security_group_id = module.mysql_security_group.sg_id
  from_port         = 3306
  protocol       = "tcp"
  to_port           = 3306
  source_security_group_id = module.backend_security_group.sg_id
}

resource "aws_security_group_rule" "backend_from_frontend" {
  type = "ingress"
  security_group_id = module.backend_security_group.sg_id
  from_port         = 8080
  protocol       = "tcp"
  to_port           = 8080
  source_security_group_id = module.frontend_security_group.sg_id
}

resource "aws_security_group_rule" "frontend_from_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend_security_group.sg_id
}

resource "aws_security_group_rule" "bastion_from_mysql" {
  type = "ingress"
  security_group_id = module.mysql_security_group.sg_id
  from_port         = 22
  protocol       = "tcp"
  to_port           = 22
  source_security_group_id = module.bastion_security_group.sg_id 
  
}

resource "aws_security_group_rule" "bastion_from_backend" {
  type = "ingress"
  security_group_id = module.backend_security_group.sg_id
  from_port         = 22
  protocol       = "tcp"
  to_port           = 22
  source_security_group_id = module.bastion_security_group.sg_id 
  
}

resource "aws_security_group_rule" "bastion_from_frontend" {
  type = "ingress"
  security_group_id = module.frontend_security_group.sg_id
  from_port         = 22
  protocol       = "tcp"
  to_port           = 22
  source_security_group_id = module.bastion_security_group.sg_id 
  
}

resource "aws_security_group_rule" "bastion_from_public" {
  type = "ingress"
  security_group_id = module.bastion_security_group.sg_id
  from_port         = 22
  protocol       = "tcp"
  to_port           = 22
  cidr_blocks = ["0.0.0.0/0"]
  
}

resource "aws_security_group_rule" "ansible_from_mysql" {
  type = "ingress"
  security_group_id = module.mysql_security_group.sg_id
  from_port         = 22
  protocol       = "tcp"
  to_port           = 22
  source_security_group_id = module.ansible_security_group.sg_id 
  
}

resource "aws_security_group_rule" "ansible_from_backend" {
  type = "ingress"
  security_group_id =  module.backend_security_group.sg_id
  from_port         = 22
  protocol       = "tcp"
  to_port           = 22
  source_security_group_id = module.ansible_security_group.sg_id
  
}

resource "aws_security_group_rule" "ansible_from_frontend" {
  type = "ingress"
  security_group_id = module.frontend_security_group.sg_id
  from_port         = 22
  protocol       = "tcp"
  to_port           = 22
  source_security_group_id = module.ansible_security_group.sg_id 
  
}

resource "aws_security_group_rule" "ansible_from_public" {
  type = "ingress"
  security_group_id = module.ansible_security_group.sg_id
  from_port         = 22
  protocol       = "tcp"
  to_port           = 22
  cidr_blocks = ["0.0.0.0/0"]
  
}