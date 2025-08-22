
# Step 1: Initializing configs and variables 
variable "tags" {
  type        = map(string)
  description = "(Optional) List of tags to be propagated accross all assets in this demo"
}

variable "workspace_name" {
  type        = string
  description = "(Required) Databricks workspace name to be used for deployment"
}

variable "cidr_block" {
  type        = string
  description = "(Required) CIDR block to be used to create the Databricks VPC"
}

variable "region" {
  type        = string
  description = "(Required) AWS region where the assets will be deployed"
}

variable "aws_profile" {
  type        = string
  description = "(Required) AWS cli profile to be used for authentication with AWS"
}

# New owner input (user OR service principal)
variable "owner" {
  description = "Owner identity; set exactly one of user_email or sp_application_id."
  type = object({
    user_email        = optional(string)
    sp_application_id = optional(string)
  })
  default = {}

  validation {
    condition = (
      ((try(var.owner.user_email, null) != null) ? 1 : 0) +
      ((try(var.owner.sp_application_id, null) != null) ? 1 : 0)
    ) == 1
    error_message = "Provide either owner.user_email or owner.sp_application_id (exactly one)."
  }
}

variable "my_username" {
  type        = string
  description = "DEPRECATED: use var.owner instead."
  default     = null
}
variable "databricks_client_id" {
  type        = string
  description = "(Required) Client ID to authenticate the Databricks provider at the account level"
}

variable "databricks_client_secret" {
  type        = string
  description = "(Required) Client secret to authenticate the Databricks provider at the account level"
}

variable "databricks_account_id" {
  type        = string
  description = "(Required) Databricks Account ID"
}

variable "databricks_users" {
  description = <<EOT
  List of Databricks users to be added at account-level for Unity Catalog.
  Enter with square brackets and double quotes
  e.g ["first.last@domain.com", "second.last@domain.com"]
  EOT
  type        = list(string)
}

variable "databricks_metastore_admins" {
  description = <<EOT
  List of Admins to be added at account-level for Unity Catalog.
  Enter with square brackets and double quotes
  e.g ["first.admin@domain.com", "second.admin@domain.com"]
  EOT
  type        = list(string)
}

variable "unity_admin_group" {
  description = "(Required) Name of the admin group. This group will be set as the owner of the Unity Catalog metastore"
  type        = string
}

variable "aws_access_services_role_name" {
  type        = string
  description = "(Optional) Name for the AWS Services role by this module"
  default     = null
}
