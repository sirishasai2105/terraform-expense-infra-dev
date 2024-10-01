locals {
    name = "${var.project_name}-${var.environment}"
    #bastion-id = data.aws_ssm_parameter.bastion_sg_id.value
    public-subnet-id = split(",", data.aws_ssm_parameter.public_subnet_id.value)[0]
    #ami-id = data.aws_ami.ami_info.id.id
    mysql-sg-id = data.aws_ssm_parameter.mysql_sg_id.value
    backend-sg-id = data.aws_ssm_parameter.backend_sg_id.value
    ansible-sg-id = data.aws_ssm_parameter.ansible_sg_id.value
    frontend-sg-id = data.aws_ssm_parameter.frontend_sg_id.value
    private-subnet-id = split(",",data.aws_ssm_parameter.private_subnet_id.value)[0]
    database-subnet-id = split(",",data.aws_ssm_parameter.database_subnet_id.value)[0]
}