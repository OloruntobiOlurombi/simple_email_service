# IAM user credentials output
output "smtp_username" {
  # value = aws_iam_access_key.user.id
  value = aws_iam_access_key.access_key.id
}

output "smtp_password" {
  value     = aws_iam_access_key.access_key.ses_smtp_password_v4
  sensitive = true
}

output "smpt_email_address" {
value = aws_ses_email_identity.email.email
}