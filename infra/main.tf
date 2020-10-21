module "aws_website_001" {
    source              = "./website"
    source_owner        = "technicaljones"
    source_repo         = "aws-website"
    domain_name         = "technicaljones.net"
    short_name          = "technicaljones"
    owned_domain        = true
    github_oauth_token  = var.github_oauth_token

    providers = {
        aws.us-east-1 = aws.us-east-1
    }
}
