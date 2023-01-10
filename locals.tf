locals {
  # Get a name from the descriptor. If not available, use default naming convention.
  # Trim and replace function are used to avoid bare delimiters on both ends of the name and situation of adjacent delimiters.
  name_from_descriptor = module.database_label.enabled ? trim(replace(
    lookup(module.database_label.descriptors, var.descriptor_name, module.database_label.id), "/${module.database_label.delimiter}${module.database_label.delimiter}+/", module.database_label.delimiter
  ), module.database_label.delimiter) : null

  create_default_roles = module.this.enabled && var.create_default_roles

  default_roles_definition = {
    readonly = {
      database_grants = ["USAGE", "MONITOR"]
    }
    admin = {
      database_grants = ["USAGE", "MONITOR", "MODIFY", "OWNERSHIP", "REFERENCE_USAGE", "CREATE SCHEMA"]
      schema_grants   = ["MONITOR", "CREATE TEMPORARY TABLE", "CREATE TAG", "CREATE PIPE", "CREATE PROCEDURE", "CREATE MATERIALIZED VIEW", "CREATE ROW ACCESS POLICY", "USAGE", "CREATE TABLE", "CREATE FILE FORMAT", "CREATE STAGE", "CREATE TASK", "CREATE FUNCTION", "CREATE EXTERNAL TABLE", "ADD SEARCH OPTIMIZATION", "MODIFY", "OWNERSHIP", "CREATE SEQUENCE", "CREATE MASKING POLICY", "CREATE VIEW", "CREATE STREAM"]
    }
  }

  provided_roles = { for role_name, role in var.roles : role_name => {
    for k, v in role : k => v
    if v != null
  } }
  roles_definition = module.roles_deep_merge.merged

  default_roles = {
    for role_name, role in local.roles_definition : role_name => role
    if contains(keys(local.default_roles_definition), role_name)
  }
  custom_roles = {
    for role_name, role in local.roles_definition : role_name => role
    if !contains(keys(local.default_roles_definition), role_name)
  }

  roles = {
    for role_name, role in merge(
      module.snowflake_default_role,
      module.snowflake_custom_role
    ) : role_name => role
    if role.name != null
  }
}

module "roles_deep_merge" {
  source  = "Invicton-Labs/deepmerge/null"
  version = "0.1.5"

  maps = [local.default_roles_definition, local.provided_roles]
}
