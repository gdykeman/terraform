terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "gdykeman"

    workspaces {
      name = "AWS"
    }
  }
}

provider "aws" {
  region = terraform.workspace == "AWS" ? "us-east-1" : "us-east-2"
}

data "aws_ami" "rhel" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = [var.aws_info.ec2_ami_name]
  }

  filter {
    name   = "architecture"
    values = [var.aws_info.ec2_ami_arch]
  }
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${terraform.workspace}-vpc"
  cidr = var.aws_info.vpc_cidr

  azs            = terraform.workspace == "AWS" ? ["us-east-1a"] : ["us-east-2a"]
  public_subnets = var.aws_info.vpc_public_subnets
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
  instance_type   = var.aws_info.ec2_type
  security_groups = [aws_security_group.sg.id]
  user_data       = fileexists("script.sh") ? file("script.sh") : null
  key_name        = var.aws_info.ec2_key_name

  tags = {
    Name = "${terraform.workspace}-ec2"
  }
}