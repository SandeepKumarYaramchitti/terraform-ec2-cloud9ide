# EC2 ID
output "id" {
  value = aws_cloud9_environment_ec2.cloudysky_cloud9_instance.id
}

# EC2 ARN
output "arn" {
  value = aws_cloud9_environment_ec2.cloudysky_cloud9_instance.arn
}

# cloud9 url
output "cloud9_url" {
  value = "https://${var.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.cloudysky_cloud9_instance.id}"
}

