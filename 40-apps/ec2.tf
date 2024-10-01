module "mysql_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_info.id

  name = "${local.name}-${var.mysql_tags}"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.mysql-sg-id]
  subnet_id              = local.database-subnet-id 

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "backend_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_info.id

  name = "${local.name}-${var.backend_tags}"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.backend-sg-id]
  subnet_id              = local.private-subnet-id 

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "frontend_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_info.id

  name = "${local.name}-${var.frontend_tags}"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.frontend-sg-id]
  subnet_id              = local.public-subnet-id 

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ansible_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_info.id

  name = "${local.name}-${var.ansible_tags}"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.ansible-sg-id]
  subnet_id              = local.public-subnet-id 
  user_data = file("expense.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [
        module.mysql_ec2.private_ip
      ]
      allow_overwrite = true
    },

    {
      name    = "backend"
      type    = "A"
      ttl     = 1
      records = [
        module.backend_ec2.private_ip
      ]
      allow_overwrite = true
    },

    {
      name    = "frontend"
      type    = "A"
      ttl     = 1
      records = [
        module.frontend_ec2.private_ip
      ]
      allow_overwrite = true
    },

        {
      name    = ""
      type    = "A"
      ttl     = 1
      records = [
        module.frontend_ec2.public_ip
      ]
      allow_overwrite = true
    }
  ]

}
