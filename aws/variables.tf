variable "aws_info" {
  type = object({
    ec2_type           = string
    ec2_ami_name       = string
    ec2_ami_arch       = string
    ec2_key_name       = string
    vpc_cidr           = string
    vpc_prod_az        = list(string)
    vpc_dev_az         = list(string)
    vpc_public_subnets = list(string)
  })
  default = {
    ec2_type           = "t3.micro"
    ec2_ami_name       = "RHEL-8*"
    ec2_ami_arch       = "x86_64"
    ec2_key_name       = "gdykeman"
    vpc_cidr           = "10.0.0.0/16"
    vpc_prod_az        = ["us-east-1a"]
    vpc_dev_az         = ["us-east-2a"]
    vpc_public_subnets = ["10.0.1.0/24"]
  }
}

variable "rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    proto       = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = -1
      to_port     = -1
      proto       = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 5432
      to_port     = 5432
      proto       = "tcp"
      cidr_blocks = ["10.10.10.10/32"]
    }
  ]
}