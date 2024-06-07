# Import AWS Organizations
import {
  to = aws_organizations_organization.org
  id = "o-0p2vzj2l6i"
}

# Enable AWS Organizations
resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "securityhub.amazonaws.com"
  ]

  feature_set = "ALL"
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
}

resource "null_resource" "enable_iam_identity_center_trusted_access" {
  provisioner "local-exec" {
    command = "aws organizations enable-aws-service-access --service-principal sso.amazonaws.com"
  }

}

# Output the root organizational unit (OU) ID
output "root_ou_id" {
  value = aws_organizations_organization.org.roots[0].id
}

output "master_account_id" {
  value = aws_organizations_organization.org.accounts[0].id
}

# Define a child organizational unit
resource "aws_organizations_organizational_unit" "child_ou_1" {
  name      = "Bolt_Dev"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "child_ou_2" {
  name      = "Bolt_PE"
  parent_id = aws_organizations_organization.org.roots[0].id
}

