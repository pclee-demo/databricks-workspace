locals {
  # Prefer owner.user_email → fallback to legacy my_username → else derive from SP app ID (no data lookups here)
  owner_tag = (
    try(var.owner.user_email, null) != null
    ? var.owner.user_email
    : (
      var.my_username != null
      ? var.my_username
      : (
        try(var.owner.sp_application_id, null) != null
        ? "spn-${var.owner.sp_application_id}"
        : "unknown"
      )
    )
  )

  # "Email-like" tag value; for SP we store the application_id (string) to avoid lookups
  owner_email = (
    try(var.owner.user_email, null) != null
    ? var.owner.user_email
    : (
      var.my_username != null
      ? var.my_username
      : (
        try(var.owner.sp_application_id, null) != null
        ? var.owner.sp_application_id
        : null
      )
    )
  )

  # Placeholder: no workspace/account lookup here to avoid cycles.
  # If you need the SP ID for permissions, resolve it AFTER the workspace is created.
  owner_sp_id = null

  # Guard: don’t allow both legacy my_username and new owner.* at once
  both_owner_and_legacy = (
    var.my_username != null &&
    (try(var.owner.user_email, null) != null || try(var.owner.sp_application_id, null) != null)
  )
}

# Terraform ≥ 1.5: fail early if both are set
output "inputs_ok" {
  value = true
  precondition {
    condition     = !local.both_owner_and_legacy
    error_message = "Do not set my_username when owner.* is provided. Use exactly one."
  }
}
