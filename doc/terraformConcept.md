. What terraform plan Actually Does

👉 It does NOT create anything

It only tells you:

“If I run apply, THIS is what I will do”

🔍 2. Understanding Your Output

You saw:

+ create

👉 Meaning:

+ → something will be created
🔹 This line is the most important:
# aws_vpc.main_vpc will be created

👉 Translation:

Resource type → aws_vpc
Terraform name → main_vpc

👉 So:

“A new VPC will be created”

🔹 Inside the block:
+ cidr_block = "10.0.0.0/16"

👉 This is YOUR input
👉 Matches your code

🔹 These lines:
+ arn = (known after apply)
+ id  = (known after apply)

👉 Means:

AWS will generate these AFTER creation
Terraform doesn’t know them yet
🔹 This line:
+ enable_dns_support = true

👉 Interesting point 👇

You did NOT explicitly write this
👉 AWS sets it by default

🔹 Summary line:
Plan: 1 to add, 0 to change, 0 to destroy

👉 Meaning:

1 resource → will be created
nothing modified
nothing deleted
🧠 3. How to Read Plan Like an Engineer

Whenever you run terraform plan, check:

✅ 1. What resources?
Are correct resources being created?
✅ 2. What values?
CIDR correct?
Region correct?
✅ 3. Any unexpected changes?
Something being deleted? 🚨
⚠️ Real Production Risk

If you see:

- destroy

👉 Be VERY careful

It means:
👉 Terraform will delete resources

📁 4. What is .terraform.lock.hcl?

You saw this file:

.terraform.lock.hcl
🧠 What it does

👉 It locks the provider version

Example:

provider "aws" {
  version = "5.x.x"
}
🔹 Why important?

Without this:

Today → version 5.0
Tomorrow → version 6.0 (breaking changes)

👉 Your infra might break ❌

✅ With lock file:

👉 Terraform always uses SAME version

🧠 Think Like This

.terraform.lock.hcl =
👉 “Freeze dependency versions”

📁 5. What is terraform.tfstate (Important!)

You mentioned state file (or will see after apply)

🧠 What is State?

👉 Terraform’s memory

It stores:

What resources exist
Their IDs
Their current state
🧠 Example

After apply:

aws_vpc.main_vpc → id = vpc-12345
❗ Why critical?

Without state:
👉 Terraform doesn’t know what it created

⚠️ Production Rule
Never delete state file ❌
Never edit manually ❌
🧠 6. Full Flow (Very Important)
Code (main.tf)
     ↓
terraform plan → preview
     ↓
terraform apply → create
     ↓
terraform.tfstate → store reality
🎯 What You Should Learn From This Step
Plan = preview (safe)
Apply = actual execution
State = memory
Lock file = version control
🚀 Now Next Step

Since your plan is correct:

👉 Run:

terraform apply

Type:

yes
👉 After Apply

You should see:

VPC created in AWS console


What Happened When You Ran terraform apply

You saw:

Do you want to perform these actions?
Enter a value: yes

👉 This is a safety checkpoint

🔐 Why Terraform Asks This?

Because:

👉 Infra changes can:

Create resources 💰 (cost)
Delete resources 💥 (data loss)

So Terraform ensures:

“Are you sure before I execute?”

🧠 2. This Line is Very Important
aws_vpc.main_vpc: Creating...

👉 Terraform is now:

Calling AWS API
Sending your configuration
🧠 3. This Line is GOLD
aws_vpc.main_vpc: Creation complete after 2s [id=vpc-0f5f49c2d56583970]
🔹 What is this ID?
vpc-0f5f49c2d56583970

👉 This is:

Unique identifier of your VPC in AWS
Used internally by AWS
🧠 Why This Matters?

Later:

Subnets will attach to this VPC
EC2 will be created inside this VPC

👉 Everything depends on this ID

🧠 4. Where is This ID Stored?

👉 Inside:

terraform.tfstate
🧠 Example (conceptually)
{
  "resources": [
    {
      "type": "aws_vpc",
      "name": "main_vpc",
      "id": "vpc-0f5f49c2d56583970"
    }
  ]
}
❗ Why This is Critical

Terraform now knows:

👉 “I already created this VPC”

So next time:

It won’t recreate it
It will update if needed
🧠 5. What If You Run terraform apply Again?

👉 Nothing will happen

Because:

No changes. Infrastructure is up-to-date.
🧠 6. Real Engineer Thinking

After apply, always verify:

🔍 Go to AWS Console

👉 VPC Dashboard → Your VPCs

Check:

CIDR = 10.0.0.0/16
State = available
🧠 7. What You Have Right Now

👉 You created:

A private network
With:
IP range
default route table
default security group
❗ But IMPORTANT

Right now:

❌ No internet access
❌ No subnets
❌ No EC2

👉 It’s just an empty network

🧠 8. What You Learned (Very Important)
Plan = preview
Apply = execution
State = memory
Resource ID = AWS identity
🚀 Now Next Step (Continue Learning Style)

We continue one line at a time

👉 Next line to add:
enable_dns_support = true
🧠 Why This Matters

Without DNS:

Services must talk via IP ❌
Hard to scale

With DNS:

Services can talk via names ✅
👉 Your Task
Add this line
Run:
terraform plan



First: What is terraform.tfstate (in one line)

👉 It is Terraform’s source of truth about what exists in AWS

❗ Important Mindset

👉 As a developer, you do NOT read this file daily

👉 But you MUST understand what it contains

🧱 Think Like This
Code (main.tf) = Desired state
AWS = Actual state
tfstate = Terraform’s memory of actual state
🧠 Now Let’s Decode YOUR State File (Only What Matters)

I’ll filter important vs not important

✅ 1. MOST IMPORTANT SECTION
🔹 This block:
"type": "aws_vpc",
"name": "main_vpc"

👉 Maps to your code:

resource "aws_vpc" "main_vpc"
🔹 This is VERY IMPORTANT:
"id": "vpc-0f5f49c2d56583970"

👉 This is:

Real AWS resource ID
Used for:
updates
deletes
linking other resources
🧠 Rule

👉 Always understand:

Terraform tracks resources using IDs in state

✅ 2. ATTRIBUTES (Important vs Not)

Inside:

"attributes": { ... }
🔹 Important attributes (YOU SHOULD CARE)
"cidr_block": "10.0.0.0/16"
"enable_dns_support": true
"enable_dns_hostnames": false

👉 Why?

Because:

These affect your infrastructure behavior
🔹 Important system-generated values
"default_route_table_id"
"default_security_group_id"
"default_network_acl_id"

👉 These are useful when:

You start modifying networking
🔹 Less important (ignore mostly)
"arn"
"owner_id"
"region"
"private"
"schema_version"

👉 These are internal metadata

⚠️ 3. CRITICAL THING TO NOTICE
"enable_dns_hostnames": false

👉 This is VERY IMPORTANT

You didn’t set it → AWS defaulted it

🧠 Why this matters?

Later:

Load balancer
internal DNS
service discovery

👉 may not work properly

🧠 4. WHAT YOU SHOULD CHECK AFTER EVERY CHANGE

When you modify Terraform code, check:

✅ 1. Resource exists?
"type": "aws_vpc"
"id": "vpc-xxxx"
✅ 2. Key configuration values
CIDR
DNS settings
tags
✅ 3. Unexpected changes

If something changes unexpectedly:
👉 compare state vs plan

🚫 What You SHOULD NOT Do
❌ Don’t edit this file manually
❌ Don’t rely on reading it for debugging first
🧠 When Do Developers Actually Use State?
Real scenarios:
🔹 1. Debugging drift
Infra changed manually in AWS
Terraform behaves weirdly
🔹 2. Importing resources
Existing AWS resource → Terraform
🔹 3. Remote state (important later)
Teams share state via S3
🔥 Most Important Insight

👉 You should trust:

terraform plan → for changes
NOT state file directly
🧠 Simplified Rule
Thing	Should You Check?
terraform plan	✅ ALWAYS
terraform apply output	✅ ALWAYS
tfstate file	⚠️ only when debugging
🚀 What YOU Should Focus On Now

Instead of state file:

👉 Focus on:

What you wrote in code
What plan shows
What AWS actually has


Important Concept You Just Saw

This line:

Refreshing state...
🔹 What it means

Terraform is doing:

👉 “Let me check AWS real infra first”

So:

State file ↔ AWS actual state

are synced before comparison

🧠 Then Terraform Compares:
Your code (main.tf)
VS
Real AWS infra
👉 If SAME → No changes
👉 If DIFFERENT → Plan shows update
🧠 Why This is VERY IMPORTANT

This is called:

👉 Declarative Infrastructure

You say:

“This is how I want infra”

Terraform ensures:

“Reality matches this”

What Your Output Means

You saw:

~ update in-place

👉 This symbol ~ is very important.

🔹 Meaning of Symbols in Terraform
Symbol	Meaning
+	create
-	destroy
~	update
🔥 Your Case
# aws_vpc.main_vpc will be updated in-place

👉 Translation:

“Terraform will NOT recreate your VPC
It will MODIFY the existing one”

🧠 This Line is the Key
enable_dns_hostnames = false -> true
🔍 What is happening?
Current AWS state → false
Your code → true

👉 Terraform detected difference

🧠 So Terraform decided:

“I’ll update only this property, not recreate the VPC”

⚠️ Why This is VERY IMPORTANT (Real World)

Imagine:

Your VPC has:
EC2
DB
Load balancer

If Terraform recreated VPC:
👉 Everything would be destroyed 💥

✅ But because of “in-place update”

👉 Only this setting changes
👉 Infra stays intact

🧠 How Terraform Knows This?

From:

👉 Provider schema (AWS provider)

It knows:

Which fields require recreation
Which can be updated safely
🧠 This is Called

👉 Immutable vs Mutable changes

Example:
Change	Behavior
CIDR block change	❌ recreate VPC
DNS hostname	✅ update in-place
🔍 What You Should Check in Plan (Important Habit)

Whenever you see a plan:

✅ 1. Type of action
create?
update?
destroy? 🚨
✅ 2. What is changing

Here:

false -> true

👉 Always verify:

Is this expected?
Is this safe?
✅ 3. Any hidden risk

If you see:

-/+ destroy and recreate

👉 Be VERY careful

🧠 What You Just Learned

This is a BIG milestone:

Terraform compares state vs code
It generates a diff
Applies minimal changes


What is terraform.tfstate.backup?

👉 It is a backup of the previous state file

🔍 What Happens Internally

Whenever you run:

terraform apply

Terraform does:

1. Take current state → save as backup
2. Write new state → terraform.tfstate
🧠 So Yes — Your Understanding is Almost Correct

👉 The backup file is:

The last version of your state BEFORE the latest change

🔁 Example (Your Case)
Step 1: First apply
terraform.tfstate → serial = 1

(No backup yet or initial backup)

Step 2: Second apply (DNS change)

Before updating:

👉 Terraform copies:

terraform.tfstate → terraform.tfstate.backup

Then updates:

terraform.tfstate → serial = 3
🔍 So now:
File	Meaning
terraform.tfstate	latest state
terraform.tfstate.backup	previous state
🧠 Why This Exists (VERY IMPORTANT)

👉 Safety mechanism

🧯 Real Scenario

Suppose:

State gets corrupted ❌
Wrong apply happened ❌

👉 You can restore from backup

⚠️ Important Clarification

“Will there always be two files?”

👉 Locally: Yes

terraform.tfstate
terraform.tfstate.backup
❗ But in real projects:

👉 We DO NOT use local state

We use:

S3 (remote state)
with versioning
🧠 Important Behavior

👉 Backup file always contains:

State just before last apply

❗ Not multiple versions
Only ONE backup
Not full history
🔥 Limitation

If you run apply multiple times:

👉 Backup gets overwritten

🧠 Real Production Approach

Instead of relying on .backup:

👉 We use:

S3 bucket
versioning enabled
state locking (DynamoDB)
🧠 What YOU Should Do as Developer
✅ When to care about backup file
State corruption
Debugging unexpected change
Accidental deletion
❌ When NOT to care
Day-to-day development
normal workflow
🧠 Final Mental Model
terraform.tfstate        → current truth
terraform.tfstate.backup → previous truth
🎯 Answer to Your Question

Backup file = exactly last version?
What Your Plan Is Saying
🔹 Key line:
~ update in-place

👉 Terraform will modify the existing VPC, not recreate it

🔍 Most Important Part
~ tags = {
    + "Name" = "main_vpc"
}
🧠 Meaning
Earlier → no tags ({})
Now → adding:
Name = main_vpc

👉 + means addition

🔍 What is tags_all?

You saw:

~ tags_all = {
    + "Name" = "main_vpc"
}
🧠 Difference
Field	Meaning
tags	What YOU define
tags_all	Final tags (including defaults, provider-level tags)
🧠 In your case

Since you only added:

tags = {
  Name = "main_vpc"
}

👉 Both look same

🔥 In real projects

If provider has default tags:

provider "aws" {
  default_tags {
    tags = {
      Environment = "dev"
    }
  }
}

Then:

tags      → your tags
tags_all  → your tags + default tags
🧠 Why Tags Matter (Real World)

This is NOT just naming.

🏢 In companies:

Tags are used for:

💰 Cost tracking
Which team is using money?
👤 Ownership
Who owns this resource?
🌍 Environment
dev / staging / prod
🔥 Example (enterprise)
tags = {
  Name        = "main-vpc"
  Environment = "dev"
  Owner       = "sumit"
}
🧠 What You Should Check in Plan (Important Habit)

Whenever you run plan:

✅ 1. Action type
Plan: 0 to add, 1 to change, 0 to destroy

👉 Safe change

✅ 2. Exact change
+ "Name" = "main_vpc"

👉 Expected change

❌ What would be dangerous?

If you saw:

- destroy

or:

-/+ recreate

👉 That’s risky


Why This Exists

Because in real companies:

You don’t want developers to manually add same tags everywhere
You enforce global tagging rules
🏢 Real-World Example

Company rule:

Every resource must have:
- Environment
- CostCenter
- Project
Instead of writing everywhere:
tags = {
  Name        = "..."
  Environment = "dev"
  CostCenter  = "123"
}
You define once in provider:
default_tags {
  tags = {
    Environment = "dev"
    CostCenter  = "123"
  }
}
🧠 So Flow Becomes
Your tags        → tags
Provider tags    → added automatically
Final result     → tags_all
🔥 Important Insight

👉 tags_all is what AWS ACTUALLY sees

👉 tags is just your input

⚠️ Important Rule

👉 If same key exists in both:

tags = {
  Environment = "prod"
}

and provider:

Environment = "dev"

👉 Result:

Environment = "prod"   ✅ your value wins
🧠 Final Mental Model
tags      = what you define
tags_all  = what actually gets applied
🚀 Your Task (Do This)
Add default_tags in provider
Run:
terraform plan
Observe difference between:
tags
tags_all