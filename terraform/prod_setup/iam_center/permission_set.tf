# Create Permission Set
resource "aws_ssoadmin_permission_set" "admin_access_pe_set" {
  instance_arn = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.arns)[0]
  name = "PE_Admin_Set"
}

resource "aws_ssoadmin_account_assignment" "pe_account_assignment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.admin_access_pe_set.arn

  principal_id   = aws_identitystore_group.pe_group.group_id
  principal_type = "GROUP"

  target_id   = "424439628261"
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_managed_policy_attachment" "pe_policy_attachment" {
  # Adding an explicit dependency on the account assignment resource will
  # allow the managed attachment to be safely destroyed prior to the removal
  # of the account assignment.
  depends_on = [aws_ssoadmin_account_assignment.pe_account_assignment]

  instance_arn       = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.admin_access_pe_set.arn
}


# ----

resource "aws_iam_policy" "admin_policy_dev_ou" {
  name        = "AdminDev"
  description = "Admin Policy on Dev OU"
  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": [
				"*"
			],
			"Resource": [
				"arn:aws:organizations::*:ou/o-0p2vzj2l6i/ou-bt5f-eb5elu0a/*"
			]
		}
    	]
  })
}

resource "aws_ssoadmin_permission_set" "dev_set" {
  name         = "Dev_Set"
  instance_arn = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.arns)[0]
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "dev_attachment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.dev_set.arn
  depends_on = [aws_ssoadmin_account_assignment.dev_account_assignment]
  customer_managed_policy_reference {
    name = aws_iam_policy.admin_policy_dev_ou.name
    path = "/"
  }
}

resource "aws_ssoadmin_account_assignment" "dev_account_assignment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.dev_set.arn

  principal_id   = aws_identitystore_group.dev_group.group_id
  principal_type = "GROUP"

  target_id   = "424439628261"
  target_type = "AWS_ACCOUNT"
}

