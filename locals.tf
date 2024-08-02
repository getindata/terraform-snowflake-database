locals {
  # Get a name from the descriptor. If not available, use default naming convention.
  # Trim and replace function are used to avoid bare delimiters on both ends of the name and situation of adjacent delimiters.
  name_from_descriptor = module.database_label.enabled ? trim(replace(
    lookup(module.database_label.descriptors, var.descriptor_name, module.database_label.id), "/${module.database_label.delimiter}${module.database_label.delimiter}+/", module.database_label.delimiter
  ), module.database_label.delimiter) : null

  create_default_roles = module.this.enabled && var.create_default_roles

  #This needs to be the same as an object in roles variable
  role_template = {
    enabled              = true
    descriptor_name      = "snowflake-role"
    comment              = null
    role_ownership_grant = "SYSADMIN"
    granted_roles        = []
    granted_to_roles     = []
    granted_to_users     = []
    database_grants      = {}
    schema_grants        = []
    schema_objects_grants = {
      "TABLE"             = []
      "DYNAMIC TABLE"     = []
      "EXTERNAL TABLE"    = []
      "VIEW"              = []
      "MATERIALIZED VIEW" = []
      "FILE FORMAT"       = []
      "FUNCTION"          = []
      "STAGE"             = []
      "TASK"              = []
      "PROCEDURE"         = []
      "SEQUENCE"          = []
      "STREAM"            = []
    }
  }

  default_roles_definition = {
    readonly = {
      database_grants = {
        privileges = ["USAGE", "MONITOR"]
      }
      schema_grants = [{
        privileges                 = ["USAGE"]
        all_schemas_in_database    = true
        future_schemas_in_database = true
      }]
    }
    transformer = {
      database_grants = {
        privileges = ["USAGE", "MONITOR", "CREATE SCHEMA"]
      }
      schema_grants = [{
        privileges                 = ["USAGE", "CREATE TEMPORARY TABLE", "CREATE TAG", "CREATE PIPE", "CREATE PROCEDURE", "CREATE MATERIALIZED VIEW", "CREATE TABLE", "CREATE FILE FORMAT", "CREATE STAGE", "CREATE TASK", "CREATE FUNCTION", "CREATE EXTERNAL TABLE", "CREATE SEQUENCE", "CREATE VIEW", "CREATE STREAM", "CREATE DYNAMIC TABLE"]
        all_schemas_in_database    = true
        future_schemas_in_database = true
      }]
    }
    admin = {
      database_grants = {
        all_privileges = true
      }
      schema_grants = [{
        all_privileges             = true
        all_schemas_in_database    = true
        future_schemas_in_database = true
      }]
    }
  }

  provided_roles = { for role_name, role in var.roles : role_name => {
    for k, v in role : k => v
    if v != null
  } }

  roles_definition = {
    for role_name, role in module.roles_deep_merge.merged : role_name => merge(
      local.role_template,
      role
    )
  }

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
      var.create_default_roles ? module.snowflake_default_role : {},
      module.snowflake_custom_role
    ) : role_name => role
    if role_name != null
  }

  schemas = var.schemas
}

module "roles_deep_merge" {
  source  = "Invicton-Labs/deepmerge/null"
  version = "0.1.5"

  maps = [local.default_roles_definition, local.provided_roles]
}
