
resource "aws_securityhub_account" "bolt_securityhub" {
  # By default, this will enable Security Hub in the region specified in the provider block
  control_finding_generator = "STANDARD_CONTROL"
}

data "aws_region" "current" {}

resource "aws_securityhub_standards_subscription" "cis" {
  depends_on    = [aws_securityhub_account.bolt_securityhub]
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

resource "aws_securityhub_standards_subscription" "pci" {
  depends_on    = [aws_securityhub_account.bolt_securityhub]
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/pci-dss/v/3.2.1"
}

