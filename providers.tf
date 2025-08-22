provider "aws" {
  region = var.region
}

# Accounts (MWS) provider – used to create workspace, credentials, networks, etc.
provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
  # Auth: service principal at account level
  client_id     = var.databricks_client_id
  client_secret = var.databricks_client_secret
  auth_type     = "oauth-m2m"
}

# Workspace provider – used for workspace-scoped resources & lookups
# Choose ONE auth method:

# (A) OAuth M2M to workspace
provider "databricks" {
  alias         = "workspace"
  host          = module.databricks_workspace.databricks_host
  client_id     = var.databricks_client_id
  client_secret = var.databricks_client_secret
  auth_type     = "oauth-m2m"
}

# (B) PAT to workspace (use this instead of the block above)
# provider "databricks" {
#   alias = "workspace"
#   host  = module.databricks_workspace.databricks_host
#   token = var.databricks_token
# }

# Lookup the service principal INSIDE the workspace (only if sp_application_id provided)
# Must wait for the workspace to exist first.
data "databricks_service_principal" "owner" {
  count          = try(var.owner.sp_application_id, null) != null ? 1 : 0
  application_id = var.owner.sp_application_id
  provider       = databricks.workspace
  depends_on     = [module.databricks_workspace]
}
