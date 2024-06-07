# SCP to Prevent Disabling Security Hub
resource "aws_organizations_policy" "deny_disable_security_hub" {
  name        = "PreventDisablingSecurityHub"
  description = "Prevent disabling Security Hub except for the root account"
  content     = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "DenyDisableSecurityHub",
        "Effect": "Deny",
        "Action": [
          "securityhub:DisableSecurityHub"
        ],
        "Resource": "*",
        "Condition": {
          "StringNotEquals": {
            "aws:PrincipalAccount": "${aws_organizations_organization.org.accounts[0].id}"
          }
        }
      }
    ]
  })

  type = "SERVICE_CONTROL_POLICY"
}


# SCP to Prevent Disabling CloudTrail
resource "aws_organizations_policy" "deny_disable_cloudtrail" {
  name        = "PreventDisablingCloudTrail"
  description = "Prevent disabling CloudTrail except for the root account"
  content     = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "DenyDeleteCloudTrail",
        "Effect": "Deny",
        "Action": [
          "cloudtrail:DeleteTrail",
          "cloudtrail:StopLogging"
        ],
        "Resource": "*",
        "Condition": {
          "StringNotEquals": {
            "aws:PrincipalAccount": "${aws_organizations_organization.org.accounts[0].id}"
          }
        }
      }
    ]
  })

  type = "SERVICE_CONTROL_POLICY"
}

# SCP to Prevent Exposing CloudTrail Logs Publicly
resource "aws_organizations_policy" "deny_expose_cloudtrail_s3" {
  name        = "DenyExposeCloudTrailS3"
  description = "Prevent exposing CloudTrail S3 bucket publicly"
  content     = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "DenyPublicAccessS3",
        "Effect": "Deny",
        "Action": [
          "s3:PutBucketAcl",
          "s3:PutBucketPolicy",
          "s3:PutObjectAcl"
        ],
        "Resource": ["arn:aws:s3:::bolt-cloudtrail-logs-bucket", "arn:aws:s3:::bolt-cloudtrail-logs-bucket/*"]
        "Condition": {
          "StringEqualsIfExists": {
            "s3:x-amz-acl": [
              "public-read",
              "public-read-write"
            ]
          }
        }
      }
    ]
  })
  type = "SERVICE_CONTROL_POLICY"
}


# To Attach SCPs to Root OU 
resource "aws_organizations_policy_attachment" "attach_deny_disable_security_hub_root" {
  policy_id = aws_organizations_policy.deny_disable_security_hub.id
  target_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_policy_attachment" "attach_deny_disable_cloudtrail_root" {
  policy_id = aws_organizations_policy.deny_disable_cloudtrail.id
  target_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_policy_attachment" "attach_deny_expose_cloudtrail_s3_root" {
  policy_id = aws_organizations_policy.deny_expose_cloudtrail_s3.id
  target_id = aws_organizations_organization.org.roots[0].id
}

