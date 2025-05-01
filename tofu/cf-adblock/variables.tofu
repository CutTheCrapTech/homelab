variable "tofu_encryption_passphrase" {
  description = "State encryption passphrase"
  type        = string
  sensitive   = true
  default     = null
}

variable "adblock_hosts_urls" {
  type = list(string)
}

variable "cloudflare_secondary_account_id" {
  type = string
}

variable "cloudflare_secondary_api_token" {
  type      = string
  sensitive = true
}
