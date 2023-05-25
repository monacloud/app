# Configure the GitHub Provider with GITHUB_TOKEN environment variable
provider "github" {
  owner = "monacloud"
}

resource "github_actions_organization_secret" "cloudflare_token" {
  secret_name             = "CLOUDFLARE_TOKEN"
  visibility              = "selected"
  plaintext_value         = data.env_variable.cloudflare_token.value
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_secret" "cloudflare_zone_id" {
  secret_name             = "CLOUDFLARE_ZONE_ID"
  visibility              = "selected"
  plaintext_value         = data.env_variable.cloudflare_zone_id.value
  selected_repository_ids = [data.github_repository.repo.repo_id]
}