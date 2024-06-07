# IAM Identity Center enabled manually.
# Using built-in Identity Store

# To Fetch Built-in Identity Store Id
data "aws_ssoadmin_instances" "bolt_iam_identity" {}

output "arn" {
  value = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.arns)[0]
}

output "identity_store_id" {
  value = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.identity_store_ids)[0]
}

