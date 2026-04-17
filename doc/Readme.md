provider "aws" {
  region = "ap-south-1"
}
🧠 Deep Explanation
🔹 provider
Tells Terraform:
👉 “Which cloud I am using?”

You could use:

AWS
Azure
GCP

Here:
👉 We use AWS

🔹 region = "ap-south-1"

👉 This means:

All resources will be created in Mumbai
❗ Important Concept

AWS has:

Regions (Mumbai, US-East, etc.)
Each region has data centers

👉 Your infra lives inside one region

In VS Code terminal:

terraform init
🧠 What happens here?
Downloads AWS plugin
Prepares Terraform