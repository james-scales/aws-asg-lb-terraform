# Class 7 Project
# AWS Load Balancer & ASG Architecture with Terraform Modules

#### Revision Log
+ 11.13.25 Initial Deployment - VPC network, subnets, security groups, igw, nat gateway, route tables, ec2 in modularized format

## Overview
Currently this is an ongoing project building an AWS networking infrastructure. This is the foundation of what will become a fully functional Load Balancing & Auto-scaling group built out in Terraform. This project will be built out to be a reusable module and the specfic attributes can be revised as needed.  

## Prerequisites
1. Have an AWS account
2. Have AWS credentials 
3. Have a user data script for your EC2 instance
4. Have a .gitignore file
5. Install VS Code and open with your project
6. Open GitBash in VS Code

### User Data Shell Script
Example user data script if not available

```bash
curl -O https://raw.githubusercontent.com/aaron-dm-mcdonald/Class7-notes/refs/heads/main/110225/user_data.sh
```

### Key Points
+ Subnets
    + The for_each meta‑argument was implemented in the network module for any user to define their preferred network architecture in the root module and the subnets will be grabbed via defined map variable to provide flexibility. While this approach enables modular customization, it introduces additional complexity when subnets are referenced across dependent resources such as NAT Gateways and Route Tables. To mitigate confusion, inline documentation has been added throughout the codebase to clarify the logic behind more intricate configurations.
