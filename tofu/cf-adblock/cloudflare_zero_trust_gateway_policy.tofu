locals {
  # Iterate through each adblock_domain_lists resource and extract its ID
  adblock_domain_lists = [for k, v in cloudflare_zero_trust_list.adblock_domain_lists : v.id]

  # Format the values: remove dashes and prepend $
  adblock_domain_lists_formatted = [for v in local.adblock_domain_lists : format("$%s", replace(v, "-", ""))]

  # Create filters to use in the policy
  adblock_ad_filters = formatlist("any(dns.domains[*] in %s)", local.adblock_domain_lists_formatted)
  adblock_ad_filter  = join(" or ", local.adblock_ad_filters)
}

resource "cloudflare_zero_trust_gateway_policy" "block_ads" {
  account_id = var.cloudflare_account_id_enark

  name        = "Block Ads"
  description = "Block Ads domains"

  enabled    = true
  precedence = 11

  # Block domain belonging to lists (defined below)
  filters = ["dns"]
  action  = "block"
  traffic = local.adblock_ad_filter

  rule_settings {
    block_page_enabled = false
  }
}

resource "cloudflare_zero_trust_gateway_policy" "block_malware" {
  account_id = var.cloudflare_account_id_enark

  name        = "Block malware"
  description = "Block known threats based on Cloudflare's threat intelligence"

  enabled    = true
  precedence = 10

  # Block all security risks
  filters = ["dns"]
  traffic = "any(dns.security_category[*] in {178 80 83 176 175 117 131 134 151 153 68})"
  action  = "block"

  rule_settings {
    block_page_enabled = true
  }
}
