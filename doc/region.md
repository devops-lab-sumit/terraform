When you only write:

region = "ap-south-1"

👉 You are choosing region only

AWS will NOT place your resources randomly
👉 You must explicitly choose Availability Zone (AZ) later
🧠 Example

Mumbai region has:

ap-south-1a
ap-south-1b
ap-south-1c

👉 These are separate data centers

❗ Important Rule (Enterprise)
Never rely on one AZ
Always design for multi-AZ (high availability)