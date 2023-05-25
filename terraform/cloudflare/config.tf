data "env_variable" "cloudflare_token" {
  name = "CLOUDFLARE_TOKEN"
}

# Cloudflare Zone ID
data "env_variable" "cloudflare_zone_id" {
  name = "CLOUDFLARE_ZONE_ID"
}

data "github_repository" "repo" {
  full_name = "monacloud/app"
}
