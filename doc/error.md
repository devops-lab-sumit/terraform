Error 1: Invalid reference (region)
Your current line:
region = ap-south-1

👉 Terraform thinks:

ap-south-1 = some variable or resource ❌
✅ Fix (VERY IMPORTANT RULE)

👉 Strings must be in quotes

✔️ Correct line:
region = "ap-south-1"
🧠 Why?

Terraform language (HCL):

"text" → string
without quotes → variable/reference
❌ Error 2: No valid credential sources

👉 This means:

Terraform cannot authenticate to AWS

🧠 Why This Happens

Terraform checks:

AWS CLI credentials
Environment variables
EC2 role (not your case)

👉 None found → error

✅ Fix This (Step-by-Step)
👉 Run this command:
aws configure
It will ask:
1. Access Key

👉 Paste from IAM user

2. Secret Key

👉 Paste from IAM user

3. Region
ap-south-1
4. Output format
json
🧠 What This Does

Creates file in your system:

~/.aws/credentials

👉 Terraform reads from here

🔍 After Fixing Both

Your main.tf should look like:

provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}
🚀 Now Run Again
terraform plan

👉 Should show:

+ aws_vpc.main_vpc will be created

Then:

terraform apply

Type:

yes
🧠 What You Just Learned (Important)
Terraform needs:
Correct syntax (quotes matter)
Authentication (AWS CLI)
⚠️ Small Pro Tip

Never hardcode credentials in Terraform code ❌
Always use:

AWS CLI config ✅
or IAM roles (later)
👉 Your Task
Fix quotes ✅
Run aws configure ✅
Run terraform plan again ✅


PS F:\GitHub Action\infra> aws configure
aws : The term 'aws' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that 
the path is correct and try again.
At line:1 char:1
+ aws configure
+ ~~~
    + CategoryInfo          : ObjectNotFound: (aws:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException

Good—this is a setup issue, not a Terraform issue. Easy to fix.

❌ Problem
aws : The term 'aws' is not recognized

👉 Means:

AWS CLI is NOT installed (or not in PATH)

🚀 Step 1: Install AWS CLI (Windows)

Go to:

👉 https://aws.amazon.com/cli/

Download:
👉 Windows (64-bit) MSI Installer

Install it (just Next → Next → Finish)

🧠 What AWS CLI Does
Lets your system talk to AWS
Terraform uses it for authentication
🚀 Step 2: Verify Installation

Close VS Code terminal → reopen it

Then run:

aws --version
✅ Expected Output
aws-cli/2.x.x Python/3.x ...
❗ If Still Not Working

👉 Restart your system once (PATH issue)

🚀 Step 3: Configure Credentials

Now run:

aws configure
Enter:
Access Key → (from IAM user)
Secret Key → (from IAM user)
Region:
ap-south-1
Output:
json
🧠 What Happens Internally

File created:

C:\Users\<your-user>\.aws\credentials

👉 Terraform reads from here automatically

🚀 Step 4: Run Terraform Again
terraform plan

👉 Now it should work

⚠️ Important Learning

You just saw:

👉 Terraform ≠ AWS access
👉 AWS CLI = authentication bridge

👉 Your Task
Install AWS CLI ✅
Run aws --version ✅
Run aws configure ✅
Run terraform plan ✅

Then tell me:

👉 "plan success"

(or paste error if any)

Then we’ll move ahead to:
🔥 DNS + production-ready VPC config

 F:\GitHub Action\infra> aws configure

Tip: You can deliver temporary credentials to the AWS CLI using your AWS Console session by running the command 'aws login'.

AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 6DZ2o5khzeSzha4Tskz9AZr8gNmwvhTrujSMKs8s
Default region name [None]: ap-south-1
Default output format [None]: 
PS F:\GitHub Action\infra> terraform plan

Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: error fetching config from profile, default, Error using profile: 
│  2, partial credentials found for profile default
│ 
│ 
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on main.tf line 1, in provider "aws":
│    1: provider "aws" {
│ 
╵
PS F:\GitHub Action\infra> 

You’re very close—but there’s a critical mistake in what you entered.

❌ Root Cause of Your Error

Error:

partial credentials found for profile default

👉 Means:

You didn’t enter Access Key ID properly

🔍 What I See

You only entered:

❌ Secret Key → provided
❌ Access Key → missing
⚠️ Important (Security First)

You just pasted your secret key in chat.

👉 You should immediately rotate/delete it in AWS.

🚨 Do This NOW

Go to AWS:

👉 IAM → Users → your user → Security credentials
👉 Delete that access key
👉 Create a new access key

🧠 Why This Matters
Secret key = password
If leaked → anyone can control your AWS ❌
✅ Fix the Credential Issue Properly
Step 1: Run again
aws configure
Step 2: Enter ALL values correctly

You must enter:

AWS Access Key ID:     AKIAxxxxxxxxxxxx
AWS Secret Access Key: xxxxxxxxxxxxxxxxx
Default region name:   ap-south-1
Default output format: json

👉 Don’t skip Access Key this time

🧠 What “Partial Credentials” Means

AWS expects:

Access Key ✅
Secret Key ✅

If one is missing:
👉 Authentication fails

🔍 Verify Credentials File

Check this file:

C:\Users\<your-user>\.aws\credentials

It should look like:

[default]
aws_access_key_id = AKIA....
aws_secret_access_key = ....
🚀 Now Run Again
terraform plan
✅ Expected Output
+ aws_vpc.main_vpc will be created
🧠 What You Just Learned
Terraform depends on AWS CLI credentials
Both keys are mandatory
Security matters (never expose keys)
👉 Your Task
Rotate/delete old key ✅
Create new key ✅
Run aws configure properly ✅
Run terraform plan again ✅

Then tell me:

👉 "plan success"

(or paste new error)

Then we’ll continue.

file inside .AWS folder in my system, one is config file where it is mentioned, provider details mentioned as APSAuth1. And in the other file credentials where secret access key and token are, secret key and secret access key are present there. So how that the other config file is generated? Is it due to Terraform initiative initially I did that created that file?

Good observation—this is exactly how you start understanding the ecosystem, not just Terraform.

🧠 Short Answer First

👉 No, Terraform did NOT create those files

These files are created by:
👉 AWS CLI (aws configure)

📁 What You Are Seeing

Inside:

C:\Users\<you>\.aws\

You’ll see two files:

1️⃣ credentials file
[default]
aws_access_key_id = AKIA...
aws_secret_access_key = ...

👉 Contains:

Access Key
Secret Key

👉 Used for:

Authentication (who you are)
2️⃣ config file
[default]
region = ap-south-1
output = json

👉 Contains:

Region
Output format

👉 Used for:

Default settings
🧠 Who Creates These?

👉 When you run:

aws configure

AWS CLI automatically creates:

credentials file ✅
config file ✅
❗ Terraform’s Role

👉 Terraform does NOT create these files
👉 Terraform simply reads them

🧠 Flow
Terraform → AWS Provider → AWS CLI Config → AWS API
🧠 Why Two Separate Files?

AWS separates concerns:

File	Purpose
credentials	Authentication
config	Configuration
🧠 About What You Saw (APSAuth1)

You mentioned something like:

APSAuth1

👉 That is likely a profile name

🧠 What is a Profile?

Instead of:

[default]

You can have:

[APSAuth1]

👉 This allows:

Multiple AWS accounts
Multiple environments (dev, prod)
🧠 Important for Terraform

If your profile is NOT default, Terraform won’t use it automatically.

👉 Example

If your config looks like:

[APSAuth1]
region = ap-south-1

Then Terraform needs:

provider "aws" {
  region  = "ap-south-1"
  profile = "APSAuth1"
}
❗ Why You Got Error Earlier

Because:

Terraform was looking for [default]
But your credentials may be under another profile
🔍 What You Should Check Now

Open:

C:\Users\<you>\.aws\credentials
Case 1: You see [default] ✅

👉 No change needed

Case 2: You see [APSAuth1] ❗

👉 Then update Terraform:

provider "aws" {
  region  = "ap-south-1"
  profile = "APSAuth1"
}
🧠 Best Practice (Enterprise)
Use profiles for:
dev
staging
prod
🎯 Summary
AWS CLI creates .aws/config and .aws/credentials
Terraform only reads them
Profile name matters
Default profile is used unless specified