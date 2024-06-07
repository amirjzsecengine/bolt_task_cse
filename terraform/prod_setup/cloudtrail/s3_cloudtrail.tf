resource "aws_s3_bucket" "cloudtrail" {
  bucket = "bolt-cloudtrail-logs-bucket" 
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/bolt-cloudtrail"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/bolt-cloudtrail"]
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "cloudtrail" {
  depends_on = [aws_s3_bucket_ownership_controls.cloudtrail]

  bucket = aws_s3_bucket.cloudtrail.id
  acl    = "private"
}


resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail.json
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

## Create a KMS key
#resource "aws_kms_key" "cloudtrail" {
#  description             = "KMS key for CloudTrail"
#  enable_key_rotation     = true
#  deletion_window_in_days = 30
#}
#
#resource "aws_iam_policy" "policy" {
#  name        = "cloudtrail_key_policy"
#  path        = "/"
#  description = "CloudtTrail policy to restrict accesses"
#
#  # Terraform's "jsonencode" function converts a
#  # Terraform expression result to valid JSON syntax.
#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Effect = "Allow"
#        Action = [
#          "kms:Decrypt",
#          "kms:GenerateDataKey",
#          "kms:DescribeKey",
#          "kms:ReEncrypt*",
#          "kms:Encrypt"
#        ]
#        Resource = [
#          "${aws_kms_key.cloudtrail.arn}"
#        ]
#      }
#    ]
#  })
#}
#
#resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_bucket_key" {
#  bucket = aws_s3_bucket.cloudtrail.id
#
#  rule {
#    apply_server_side_encryption_by_default {
#      sse_algorithm = "AES256"
#    }
#  }
#}
