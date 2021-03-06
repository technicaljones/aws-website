# aws-website
A simple website hosted in AWS

working demo: https://technicaljones.net/

## Approaches
### **EC2 VMs**
EC2 Instances in an ASG fronted by an ELB (Application) running a webserver such as nginx.

Pros:
- Most control over tech stack ie. can choose web server technology 
- Ready to run other services such as API's

Cons:
- 'Always On' cost. Even in an ASG there will always be a minimum ammount of instances running.
- Have to maintain patching, updates and security at the OS level.
- Have to maintain concurrency between instances of web files.
- More setup required for logging / monitoring. 

### **S3**
Using an s3 bucket as a webserver with cloudfront hosting the static files.

Pros:
- Cheap as only paying for storage and data transfer that you use.
- Integrated logging and analytics.
- Highly durable (11 9's) and available.
- Supports ssl for data in transit and encryption at rest.
- Cloudfront makes a better user experience for delivery of static files to larger geo audience.
- Can integrate cloudfront with services like elastic transcoder if serving high-bandwidth video content.
- Don't need to worry about running out of space / patching / managing OS level config.
- Can be later tied into APIG for dynamic applications.

Cons:
- Could be more difficult to integrate existing monitoring / security tooling.


### **Chosen appproach: S3**
## Diagram
![diagram](diagram.PNG)

## Considerations:
-----
### IAC
Terraform will be used to deploy the required resources in AWS to host the website. This has been chosen over cloudformation due to numerous reasons:
- Large open source commnity
- Ability to tap into other services outside of AWS if needed in the future. 
- Readable IAC

### CI/CD
Code Pipeline will be used to deploy changes to the website

### Availability
S3 provides 99.99% Availabiltiy over a given year and is highly avilable. It also offers 11 9s durabilty.

### Scalability
Amazon s3 is highly scalable.

### Security
Ensure segregate roles are setup for pipeline and user access.
Ensuring Relevant controls are in place on S3 bucket.
Access logs on s3 bucket
SSL in transit for s3 
Encryption at rest won't be required for the publicly accessible web content.
SSL should be enabled on the website

### Monitoring
monitoring of 4xx, 5xx, 2xx status codes on the website. 
monitoring of chaching efficiency on CDN
monitoring of storage usage in s3


### Cost
The cost will initially be minimal but could grow if lots of users access large files.

## Usage
-----
Example usage 
```
module "aws_website_001" {
    source              = "./website"
    domain_name         = "technicaljones.net"
    short_name          = "technicaljones"
    source_owner        = "technicaljones"
    source_repo         = "aws-website"
    github_oauth_token  = var.github_oauth_token
    state_bucket        = "awswebsiteterraformstate2"

    providers = {
        aws.us-east-1 = aws.us-east-1
    }
}
```

Module inputs
- source    *(required)* - Source for the module
- source_owner *(required)* - The owner / user of the GitHub repository.
- source_repo *(required)* - The name of the repository.
- source_branch - Defaults to *main*. 
- domain_name *(required)* - Domain name for the website.
- short_name *(required)* - Used for naming resource with strict naming standards.
- owned_domain - Defaults to True. Set to false if the Domain isn't owned / registerd in route53. Web address will be the cloudfront distribution link.
- github_oauth_token *(required)* - Github personal token to access git repo.
- state_bucket *(required)* - The bucket for tf state (needed for codebuild premissions).
- providers *(required)*  - ACM and various associated resoruces need to be created in us-east-1.


Module outputs
- cloudfront_domain_name - The url for the cloudfront distribution
- domain_name - The domain name used to point to the cloudfront distribution.

### Running for the first time
Requirements:
1. Create a tfvars file with the aws and github variables set correctly.
2. Create a bucket in s3 for terraform state managment that the keys from step 1 will have access to.
3. Update the provider configuration in `infra/terraform-config.tf` to point to the related bucket.
4. Set the appropriate variables for the module
5. Update buildspec with appropriate s3 bucket
6. Run:

```
cd infra
terraform init
terraform plan -var aws_region=eu-west-1 -var github_oauth_token=token
terraform apply -var aws_region=eu-west-1 -var github_oauth_token=token
```
6. Run aws s3 cp src/ s3://bucket-name --recursive
7. Add your github oauth token to the secret in secrets manager `{"token": token}`
8. You are now ready to deploy using the pipeline

### Deployment
- Deployments will be triggered of the branch specified in the module

### Alerting
 - Alerts will be sent to the SMS numbers provided to the module in the `alert_sms` variable. These alerts are based off cloudfront metrics for 5xx status codes. B

