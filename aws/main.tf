provider "aws" {
  region = terraform.workspace == "default" ? "us-east-1" : "us-east-2"
}

data "aws_ami" "rhel" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-8*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${terraform.workspace}-vpc"
  cidr = "10.0.0.0/16"

  azs            = terraform.workspace == "default" ? ["us-east-1a"] : ["us-east-2a"]
  public_subnets = ["10.0.1.0/24"]
}

resource "aws_security_group" "sg" {
  vpc_id = module.vpc.vpc_id
  name   = join("_", ["sg", module.vpc.vpc_id])
  dynamic "ingress" {
    for_each = var.rules
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-sg"
  }
}

resource "aws_instance" "instance" {
  ami             = data.aws_ami.rhel.id
  subnet_id       = module.vpc.public_subnets[0]
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg.id]
  user_data       = fileexists("script.sh") ? file("script.sh") : null
  key_name        = "gdykeman"

  tags = {
    Name = "${terraform.workspace}-ec2"
  }
}