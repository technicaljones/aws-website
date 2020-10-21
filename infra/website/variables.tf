
variable "source_owner" {
}

variable "source_repo" {
}

variable "source_branch" {
    default = "main"
}

variable "domain_name" {
}

variable "owned_domain" {
    default = true
}

variable "github_oauth_token" {
}

variable "short_name" {
}

variable "alert_sms" {
    default = []
}

variable "state_bucket" {
}