
# output "remote_bucket_arn_this" {
#   value = aws_s3_bucket.this.arn
# }

# output "remote_bucket_this" {
#   value = aws_s3_bucket.this.bucket
# }

# output "remote_ec2_arn" {
#   value = aws_instance.ec2.arn

# }

# output "remote_ec2_name" {
#   value = aws_instance.ec2.tags

# }

output "remote_dynamodb" {
  value = aws_dynamodb_table.this.arn

}

output "remote_s3" {
  value = aws_s3_bucket.page_dr.arn
}

output "remote_ec2" {
  value = aws_instance.ec2.id
}

output "remote_lb" {
  value = aws_lb.lb.dns_name
}

output "remote_api" {
  value = aws_apigatewayv2_stage.stage.invoke_url
}