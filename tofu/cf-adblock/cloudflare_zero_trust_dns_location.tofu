resource "cloudflare_zero_trust_dns_location" "homelab" {
  account_id             = var.cloudflare_secondary_account_id
  name                   = "HomeLab"
  client_default         = true
  dns_destination_ips_id = "0e4a32c6-6fb8-4858-9296-98f51631e8e6"
  ecs_support            = false
  endpoints              = {
    doh = {
      enabled = true
    }
    dot = {
      enabled = true
    }
    ipv4 = {
      enabled = true
    }
    ipv6 = {
      enabled = true
    }
  }
}

output "dns_location_homelab" {
  description = "DNS location - HomeLab"
  value       = {
    dns_destination_ipv6_block_id = cloudflare_zero_trust_dns_location.homelab.dns_destination_ipv6_block_id
    doh_subdomain                 = cloudflare_zero_trust_dns_location.homelab.doh_subdomain
    ipv4_destination              = cloudflare_zero_trust_dns_location.homelab.ipv4_destination
    ipv4_destination_backup       = cloudflare_zero_trust_dns_location.homelab.ipv4_destination_backup
    ip                            = cloudflare_zero_trust_dns_location.homelab.ip
  }
}
