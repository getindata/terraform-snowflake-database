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

  name         = local.name_from_descriptor
  is_transient = var.is_transient
  comment      = var.comment

  data_retention_time_in_days                   = var.data_retention_time_in_days
  max_data_extension_time_in_days               = var.max_data_extension_time_in_days
  external_volume                               = var.external_volume
  catalog                                       = var.catalog
  replace_invalid_characters                    = var.replace_invalid_characters
  default_ddl_collation                         = var.default_ddl_collation
  storage_serialization_policy                  = var.storage_serialization_policy
  log_level                                     = var.log_level
  trace_level                                   = var.trace_level
  suspend_task_after_num_failures               = var.suspend_task_after_num_failures
  task_auto_retry_attempts                      = var.task_auto_retry_attempts
  user_task_managed_initial_warehouse_size      = var.user_task_managed_initial_warehouse_size
  user_task_timeout_ms                          = var.user_task_timeout_ms
  user_task_minimum_trigger_interval_in_seconds = var.user_task_minimum_trigger_interval_in_seconds
  quoted_identifiers_ignore_case                = var.quoted_identifiers_ignore_case
  enable_console_output                         = var.enable_console_output
}

module "snowflake_default_role" {
  for_each = local.default_roles

  source  = "getindata/database-role/snowflake"
  version = "1.1.1"
  context = module.this.context

  database_name   = one(snowflake_database.this[*].name)
  name            = each.key
  comment         = lookup(each.value, "comment", null)
  enabled         = local.create_default_roles && lookup(each.value, "enabled", true)
  descriptor_name = lookup(each.value, "descriptor_name", "snowflake-role")

  granted_to_roles          = lookup(each.value, "granted_to_roles", [])
  granted_to_database_roles = lookup(each.value, "granted_to_database_roles", [])
  granted_database_roles    = lookup(each.value, "granted_database_roles", [])
  database_grants           = lookup(each.value, "database_grants", {})
  schema_grants             = lookup(each.value, "schema_grants", [])
  schema_objects_grants     = lookup(each.value, "schema_objects_grants", {})

  depends_on = [
    snowflake_database.this
  ]
}

module "snowflake_custom_role" {
  for_each = local.custom_roles

  source  = "getindata/database-role/snowflake"
  version = "1.1.1"
  context = module.this.context

  database_name   = one(snowflake_database.this[*].name)
  name            = each.key
  comment         = lookup(each.value, "comment", null)
  enabled         = lookup(each.value, "enabled", true)
  descriptor_name = lookup(each.value, "descriptor_name", "snowflake-role")

  granted_to_roles          = lookup(each.value, "granted_to_roles", [])
  granted_to_database_roles = lookup(each.value, "granted_to_database_roles", [])
  granted_database_roles    = lookup(each.value, "granted_database_roles", [])
  database_grants           = lookup(each.value, "database_grants", {})
  schema_grants             = lookup(each.value, "schema_grants", [])
  schema_objects_grants     = lookup(each.value, "schema_objects_grants", {})

  depends_on = [
    snowflake_database.this
  ]
}

module "snowflake_schema" {
  for_each = local.schemas

  source  = "getindata/schema/snowflake"
  version = "2.0.0"

  context         = module.this.context
  enabled         = local.enabled && each.value.enabled
  descriptor_name = each.value.descriptor_name

  name                = each.key
  is_transient        = each.value.is_transient
  with_managed_access = each.value.with_managed_access
  comment             = each.value.comment
  database            = one(snowflake_database.this[*].name)

  skip_schema_creation                          = each.value.skip_schema_creation
  data_retention_time_in_days                   = each.value.data_retention_time_in_days
  max_data_extension_time_in_days               = each.value.max_data_extension_time_in_days
  external_volume                               = each.value.external_volume
  catalog                                       = each.value.catalog
  replace_invalid_characters                    = each.value.replace_invalid_characters
  default_ddl_collation                         = each.value.default_ddl_collation
  storage_serialization_policy                  = each.value.storage_serialization_policy
  log_level                                     = each.value.log_level
  trace_level                                   = each.value.trace_level
  suspend_task_after_num_failures               = each.value.suspend_task_after_num_failures
  task_auto_retry_attempts                      = each.value.task_auto_retry_attempts
  user_task_managed_initial_warehouse_size      = each.value.user_task_managed_initial_warehouse_size
  user_task_timeout_ms                          = each.value.user_task_timeout_ms
  user_task_minimum_trigger_interval_in_seconds = each.value.user_task_minimum_trigger_interval_in_seconds
  quoted_identifiers_ignore_case                = each.value.quoted_identifiers_ignore_case
  enable_console_output                         = each.value.enable_console_output
  pipe_execution_paused                         = each.value.pipe_execution_paused

  stages = each.value.stages
  roles  = each.value.roles

  create_default_roles = coalesce(each.value.create_default_roles, var.create_default_roles)

  depends_on = [
    snowflake_database.this
  ]
}
