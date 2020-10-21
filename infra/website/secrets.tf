resource "aws_secretsmanager_secret" "github_oauth" {
  name = "github_oauth_token"
}