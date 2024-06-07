# Define an IAM policy that restricts access to a specific EC2 instance
resource "aws_iam_policy" "web_app_policy" {
  name        = "WebAppAccessPolicy"
  description = "Policy to restrict access to a specific EC2 instance"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances"
        ]
        Resource = [
          "arn:aws:ec2:eu-north-1:${data.aws_caller_identity.current.account_id}:instance/${aws_instance.web_app.id}"
        ]
      }
    ]
  })
}

data "aws_caller_identity" "current" {}


