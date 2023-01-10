module "database_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = module.this.context

  delimiter           = coalesce(module.this.context.delimiter, "_")
  regex_replace_chars = coalesce(module.this.context.regex_replace_chars, "/[^_a-zA-Z0-9]/")
  label_value_case    = coalesce(module.this.context.label_value_case, "upper")
}

resource "snowflake_database" "this" {
  count = module.this.enabled ? 1 : 0

  name    = local.name_from_descriptor
  comment = var.comment

  data_retention_time_in_days = var.data_retention_time_in_days
  is_transient                = var.is_transient

  from_database = var.from_database
  from_replica  = var.from_replica
  from_share    = var.from_share
}

module "snowflake_default_role" {
  for_each = local.default_roles

  source  = "getindata/role/snowflake"
  version = "1.0.3"
  context = module.this.context
  enabled = local.create_default_roles && lookup(each.value, "enabled", true)

  name       = each.key
  attributes = [one(snowflake_database.this[*].name)]

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])
}


module "snowflake_custom_role" {
  for_each = local.custom_roles

  source  = "getindata/role/snowflake"
  version = "1.0.3"
  context = module.this.context
  enabled = module.this.enabled && lookup(each.value, "enabled", true)

  name       = each.key
  attributes = [one(snowflake_database.this[*].name)]

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])
}

module "snowflake_schema" {
  for_each = var.schemas

  source  = "getindata/schema/snowflake"
  version = "1.0.1"
  context = module.this.context

  name     = each.key
  database = one(snowflake_database.this[*].name)

  data_retention_days = each.value.data_retention_days
  is_transient        = each.value.is_transient
  is_managed          = each.value.is_managed

  create_default_roles = coalesce(each.value.create_default_roles, var.create_default_roles)
  roles                = each.value.roles
}

resource "snowflake_database_grant" "this" {
  for_each = module.this.enabled ? transpose({ for role_name, role in local.roles : local.roles[role_name].name =>
    lookup(local.roles_definition[role_name], "database_grants", [])
    if lookup(local.roles_definition[role_name], "enabled", true)
  }) : {}

  database_name = one(snowflake_database.this[*].name)
  privilege     = each.key
  roles         = each.value
}

resource "snowflake_schema_grant" "this" {
  for_each = module.this.enabled ? transpose({ for role_name, role in local.roles : local.roles[role_name].name =>
    lookup(local.roles_definition[role_name], "schema_grants", [])
    if lookup(local.roles_definition[role_name], "enabled", true)
  }) : {}

  database_name = one(snowflake_database.this[*].name)
  on_future     = true
  privilege     = each.key
  roles         = each.value
}
