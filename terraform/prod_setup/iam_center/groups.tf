# Create Groups
resource "aws_identitystore_group" "dev_group" {
  display_name      = "Dev"
  description       = "Developers Group"
  identity_store_id = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.identity_store_ids)[0]
}

resource "aws_identitystore_group" "pe_group" {
  display_name      = "PE"
  description       = "Platform Engineers Group"
  identity_store_id = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.identity_store_ids)[0]
}

# Define Group Membership
resource "aws_identitystore_group_membership" "dev_1" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.identity_store_ids)[0]
  group_id          = aws_identitystore_group.dev_group.group_id
  member_id         = aws_identitystore_user.dev_1.user_id
}

resource "aws_identitystore_group_membership" "pe_1" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.identity_store_ids)[0]
  group_id          = aws_identitystore_group.pe_group.group_id
  member_id         = aws_identitystore_user.pe_1.user_id
}

