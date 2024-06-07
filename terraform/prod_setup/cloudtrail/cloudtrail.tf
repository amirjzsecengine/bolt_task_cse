resource "aws_cloudtrail" "bolt_cloudtrail" {
  depends_on = [aws_s3_bucket_policy.cloudtrail]
  name                          = "bolt-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
}
