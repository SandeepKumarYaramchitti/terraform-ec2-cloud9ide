terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "cloudysky"

    workspaces {
      name = "terraform-sandeep-aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_cloud9_environment_ec2" "cloud9_instance" {
  name                        = "cloud9_instance"
  instance_type               = "t2.medium"
  automatic_stop_time_minutes = 30
  subnet_id                   = "subnet-053560d78725d4149"

  tags = {
    Terraform = "true"
  }
}

data "aws_security_group" "cloud9_secgroup" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
      aws_cloud9_environment_ec2.cloud9_instance.id
    ]
  }
}
resource "aws_security_group_rule" "tcp_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = data.aws_security_group.cloud9_secgroup.id
}


output "cloud9_url" {
  value = "https://${var.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.cloud9_instance.id}"
}
