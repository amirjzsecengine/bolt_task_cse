# Bolt Task
## Practical Task
To provide a proper Terraform code to provision the required infrastructure and to make it more manageable for maintaining it properly, I followed the recommended practices as follows:

> [!NOTE]
> As a recommended practice, we should generate useable Terraform code, but I decided to make it simple, manageable and expandable in near future.

* In the root, there are two main folders named, **prod_setup** and **tfstate_setup**.
* Within **prod_setup** folder, there are folders named as follows:
    >cloudtrail
    
    >iam_center
    
    >infra
    
    >organizations
    
    >securityhub

The above folders contain the required code to provision and manage our as it is asked in practical task.

I will explain all folders briefly and at the end, will provide a diagram demostrating our code.

**1. cloudtrail:** It contains a separate **backend.tf** file to manage tfstate file. **cloudtrail.tf** to create our trial and **s3_cloudtrail.tf** to manage depenedent services such as S3 and required policies.

**2. iam_center:** It contains a separate **backend.tf** file to manage tfstate file. **main.tf** to call iam_identity_center data since I have it enabled already. **groups.tf**, **users.tf**and **permission_set.tf** to create and manage users, groups and permission for groups respectively.

**3. infra:** It contains a separate **backend.tf** file to manage tfstate file. **main.tf** to create our aws_instance and its reuired security_group, and **policies.tf** to restrict access over this instance to specific group.
Consider that we do not need to provide SSH security group as we can use **AWS SSM** to access our aws_instances securely.

**4. organization:** It contains a separate **backend.tf** file to manage tfstate file. **ous.tf** and **scps.tf** To create OUs, and required SCPs based on task respectively.

**5. securityhub:** It contains a separate **backend.tf** file to manage tfstate file and **securityhub.tf** to enable AWS_SecurityHub.

> [!NOTE]
> We can not restrict any action performed by the management account using SCPs as we have allow permission level for everything on top of the root SCP.

## Theoretical Task
As my theoretical task, I choose the 1st scenario:

The following architecture that I will explain to achieve our goal, is going to be based on my assumption and mentioned AWS tools. Also, I will start explainig from the user side to the server side.

**1. CloudFront between Users and ELB.**

We put CloudFront as CDN solution and we define ELB (ALB) as our Custom Origin when we are configuring Distribution on CloudFront. Consider that we can set any HTTP based Origine as Custom Origin in CloudFront distrubution config. 

**2. AWS WAF in front of CloudFront and ELB separately.**

We enable/set AWS WAF and Shield in front of CloudFront and ELB. We have the possiblity to enable Manged and Custom rules on AWS WAF based on needs.

**3. Secure CloudFront and ELB integration.**

To enhance the security of this communication, apart from using HTTPS, we need to configure a Custom HTTP Header to verify that requests are coming from CoudFront. To achieve this,
  1.  We need to configure a Custom HTTP Header such as x-origin-verify on CloudFrontto be added to requests coming from users.
  2.  We need to configure AWS WAF in front of ELB, to accept only requests containing this Custom HTTP Header. This header verification is going to be done by defining a filter rule on AWS WAF (ELB side).
  3.  Considering the confidentiality of this Custom HTTP Header value, we need to have an integration of AWS Secret Manager (KMS) and Lambda function to rotate this value periodically.
  4.  Additionally, we need to restrict access to CloudFront Public IP Addresses using security group attached to our ELB.
  5.  Finally, we need to OAC to restrict access to Origins if it is the case.

By this approach, we will be ensure that no one can get access to our ALB directly. 

**4. Secure Confidential Data up to Servers.**

We can have another level of encryption for our user sensitive data through application stack which is called Field Level Encryption.

  1. Up to 10 fields in POST request can be additionally encrypted using Asymmetric encryption.
  2. CloudFront should be configure in a way to use a Public Key to encrypt those fields.
  3. Encrypted fields can be decrypted in servers, using private key.

**5. Secure Server side.**

  1.  We need to use VPC Network Firewall to secure our VPC.
  2.  Separate Subnet for Network Firewall Endpoint, Separate Public Subnet as a DMZ to place ELB. Separate Private Subnet to place sensitive nd critical servers.
  3.  Use NACLs between Subnetes to restrict accesses based on needs (Ports and IPs).
  4.  Use Security Group on ELB and server-side (EC2, ECS, EKS).
  5.  If our application needs to talk with different components in different VPCs, it is recommended to use Private for secure and restricted commmunication between VPCs (in the same or different accounts)
  6.  As the business is growing, it is recommended to use AWS Firewall Manager to be able to manage and maintain layer 3 to 7 rules properly within all accounts.
  7.  We can also have automated rule-denition in Firewall using integration of GuardDuty, SecurityHub, EventBridge, Step Functions, and Firewall Manager as well.

**6. Logging and Monitoring.**

As a final step, having a proper monitoring for all features and components we are using to secure our web application, is recommended.

**7. Security Automation for AWS WAF**

It is recommended to use the following AWS feature for AWS WAF as a security automation tool.
https://aws.amazon.com/solutions/implementations/security-automations-for-aws-waf/


