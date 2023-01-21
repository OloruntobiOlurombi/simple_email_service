# Topic: Simple Email Service with Terraform

<img width="1118" alt="Screenshot 2023-01-21 at 7 09 48 AM" src="https://user-images.githubusercontent.com/40290711/213874734-4987c403-7042-49bd-8c76-c1f25786dbe5.png">

- Today we will be looking at creating Aws Simple Email Service using terraform.

### Overview

##### What is SES?

Amazon SES is a cloud email service provider that can integrate into any application for bulk email sending. Whether you send transactional or marketing emails, you pay only for what you use. Amazon SES also supports a variety of deployments including dedicated, shared, or owned IP addresses. Reports on sender statistics and a deliverability dashboard help businesses make every email count.

##### Prerequisites:
1. Basic Knowledge of AWS is required. 
2. Basic knowledge of terraform is required.
3. AWS CLI (Install AWS CLI) .    
4. Terraform (Install Terraform).
5. AWS Configure for user profile 

##### Project Structure 

<img width="229" alt="Screenshot 2023-01-21 at 7 45 39 AM" src="https://user-images.githubusercontent.com/40290711/213874935-edaa21d1-13c9-4d40-847b-041f28e35b17.png">

##### Let Get Started!!!

###### Step 1
- Create a file for the terraform version named versions.tf:

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
```

###### Step 2
- Create a file for the aws provider named providers.tf:

```
provider "aws" {
  region = var.region
}
```

###### Step 3
- Now we will create a main.ft file to create our SES resource:

```
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
```

###### Step 4
- When you declare variables in the root module of your configuration, you can set their values using CLI options and environment variables. In this article, we will using the environment variable to provide value for our resources in the main.tf file.
- Proceed to create a file named variables.tf:

```
variable "user_email" {
  type = string 
  default = "example@gmail.com"
}

variable "user_name" {
  type = string 
  default = "testingUser"
}

variable "region" {
    type = string 
    default = "us-east-1"
}
```

###### Step 5
- We will use terraform output. Output values make information about your infrastructure available on the command line, and can expose information for other Terraform configurations to use. Output values are similar to return values in programming languages.

- Create a file for the output named outputs.tf:

```
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
```
###### Step 6

- Next we have to use **terraform init** this will initialize our terraform project. The _terraform init_ command initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

```
terraform init
```
<img width="523" alt="Screenshot 2023-01-21 at 8 43 01 AM" src="https://user-images.githubusercontent.com/40290711/213877581-a0a32715-f3e3-408a-87f0-e8f6101be010.png">


###### Step 7

- Next we have to use **terraform plan** this will plan our terraform resources. The _terraform plan_ command lets you to preview the actions Terraform would take to modify your infrastructure, or save a speculative plan which you can apply later. The function of terraform plan is speculative: you cannot apply it unless you save its contents and pass them to a terraform apply command.

```
terraform plan
```

<img width="497" alt="Screenshot 2023-01-21 at 8 52 54 AM" src="https://user-images.githubusercontent.com/40290711/213878000-61d3312a-dcc3-4e2f-8cf9-96d7c549c254.png">

###### Step 8 

- After the terraform plan we will have use **terraform apply**. The terraform apply command executes the actions proposed in a terraform plan . It is used to deploy your infrastructure. Typically apply should be run after terraform init and terraform plan.

<img width="512" alt="Screenshot 2023-01-21 at 9 02 11 AM" src="https://user-images.githubusercontent.com/40290711/213878250-6322d5ff-5464-4e12-8dda-37131694745c.png">


<img width="480" alt="Screenshot 2023-01-21 at 9 02 54 AM" src="https://user-images.githubusercontent.com/40290711/213878340-3c705ae4-f27b-455d-a4fb-b1d366b1d996.png">

<img width="414" alt="Screenshot 2023-01-21 at 9 07 34 AM" src="https://user-images.githubusercontent.com/40290711/213878501-bc10ce1a-3b49-4a97-8022-ace596f8affb.png">


###### Step 8 

- Now let us confirm our resources on the AWS console:

<img width="1034" alt="Screenshot 2023-01-21 at 9 17 39 AM" src="https://user-images.githubusercontent.com/40290711/213879499-25bd8921-a7b8-4bf9-96db-b53bab01d874.png">

- Check your email and confirm that AWS sent you an email to verify your email address identity:

<img width="1039" alt="Screenshot 2023-01-21 at 9 23 51 AM" src="https://user-images.githubusercontent.com/40290711/213879578-0f6376f7-1717-4572-95c5-16f8f82c22fb.png">

<img width="1279" alt="Screenshot 2023-01-21 at 9 26 13 AM" src="https://user-images.githubusercontent.com/40290711/213879601-d0d6aff1-03c7-4a32-82b3-2bb552d0f9d6.png">

- Now check that your email address is verify on the Amazon SES dashboard:

<img width="1034" alt="Screenshot 2023-01-21 at 9 37 06 AM" src="https://user-images.githubusercontent.com/40290711/213879728-db1df1c8-3744-4b3f-99a6-08424d92ef0a.png">


###### Step 9

- Now that we have completed our task and can confirm that our SES is set up and ready to use. It is advisable to clean up the resource to avoid cost.

- To acheive this we will have to use the **terraform destroy** command. The terraform destroy command is a convenient way to destroy all remote objects managed by a particular Terraform configuration.

```
terraform destroy
```
<img width="516" alt="Screenshot 2023-01-21 at 9 46 40 AM" src="https://user-images.githubusercontent.com/40290711/213880199-d6db54be-114f-4fd1-a482-fbd165f59bb4.png">


<img width="512" alt="Screenshot 2023-01-21 at 9 47 59 AM" src="https://user-images.githubusercontent.com/40290711/213880202-b7fdbc2e-95be-44bd-8a1b-439b6a1f7f34.png">


#### The End




