resource "aws_ses_email_identity" "email" {
  email = var.user_email
}

# Provides an IAM access key. This is a set of credentials that allow API requests to be made as an IAM user.
resource "aws_iam_user" "user" {
  name = var.user_name
}

# Provides an IAM access key. This is a set of credentials that allow API requests to be made as an IAM user.
resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.user.name
}


# Attaches a Managed IAM Policy to SES Email Identity resource
data "aws_iam_policy_document" "policy_document" {
  statement {
    actions   = ["ses:SendEmail", "ses:SendRawEmail", "iam:ListUsers", "iam:CreateUse", "iam:CreateAccessKey", "iam:PutUserPolicy"]
    resources = [aws_ses_email_identity.email.arn]
  }
}


# Provides an IAM policy attached to a user.
resource "aws_iam_policy" "policy" {
  # name   = aws_iam_policy.policy.name
  name = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.policy_document.json
}

# Attaches a Managed IAM Policy to an IAM user
resource "aws_iam_user_policy_attachment" "user_policy" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}


