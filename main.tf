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

data "aws_subnet" "existing_subnet" {
  filter {
    name   = "vpc-id"
    values = ["vpc-048c23df4f54370a4"] # Replace with the ID of the VPC
  }

  filter {
    name   = "tag:Name"
    values = ["project-subnet-public1-us-east-1a"] # Replace with the desired subnet name
  }
}

# Set uo Cloud9 IDE
resource "aws_cloud9_environment_ec2" "cloud9_instance" {
  name                        = "cloud9_instance"
  instance_type               = "t2.medium"
  automatic_stop_time_minutes = 30
  subnet_id                   = data.aws_subnet.existing_subnet.id

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
# Allow public access to port 8080
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
