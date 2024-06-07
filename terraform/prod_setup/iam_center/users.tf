resource "aws_identitystore_user" "dev_1" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.identity_store_ids)[0]

  display_name = "dev_1"
  user_name    = "dev_1"

  name {
    given_name  = "dev_1"
    family_name = "dev_1"
  }

  emails {
    value = "dev_1@example.com"
    primary  = true
  }
}

resource "aws_identitystore_user" "pe_1" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.bolt_iam_identity.identity_store_ids)[0]

  display_name = "pe_1"
  user_name    = "pe_1"

  name {
    given_name  = "pe_1"
    family_name = "pe_1"
  }

  emails {
    value = "pe_1@example.com"
    primary  = true
  }
}


