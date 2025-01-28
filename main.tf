data "context_label" "this" {
  delimiter  = local.context_template == null ? var.name_scheme.delimiter : null
  properties = local.context_template == null ? var.name_scheme.properties : null
  template   = local.context_template

  replace_chars_regex = var.name_scheme.replace_chars_regex

  values = merge(
    var.name_scheme.extra_values,
    { name = var.name }
  )
}

resource "snowflake_database" "this" {
  name         = var.name_scheme.uppercase ? upper(data.context_label.this.rendered) : data.context_label.this.rendered
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
  drop_public_schema_on_creation                = var.drop_public_schema_on_creation
}
moved {
  from = snowflake_database.this[0]
  to   = snowflake_database.this
}

module "snowflake_default_role" {
  for_each = local.default_roles

  source  = "getindata/database-role/snowflake"
  version = "2.1.0"

  database_name     = snowflake_database.this.name
  context_templates = var.context_templates

  name = each.key
  name_scheme = merge(
    local.default_role_naming_scheme,
    lookup(each.value, "name_scheme", {})
  )
  comment = lookup(each.value, "comment", null)

  granted_to_roles          = lookup(each.value, "granted_to_roles", [])
  granted_to_database_roles = lookup(each.value, "granted_to_database_roles", [])
  granted_database_roles    = lookup(each.value, "granted_database_roles", [])
  database_grants           = lookup(each.value, "database_grants", {})
  schema_grants             = lookup(each.value, "schema_grants", [])
  schema_objects_grants     = lookup(each.value, "schema_objects_grants", {})
}

module "snowflake_custom_role" {
  for_each = local.custom_roles

  source  = "getindata/database-role/snowflake"
  version = "2.1.0"

  database_name     = snowflake_database.this.name
  context_templates = var.context_templates

  name = each.key
  name_scheme = merge(
    local.default_role_naming_scheme,
    lookup(each.value, "name_scheme", {})
  )
  comment = lookup(each.value, "comment", null)

  granted_to_roles          = lookup(each.value, "granted_to_roles", [])
  granted_to_database_roles = lookup(each.value, "granted_to_database_roles", [])
  granted_database_roles    = lookup(each.value, "granted_database_roles", [])
  database_grants           = lookup(each.value, "database_grants", {})
  schema_grants             = lookup(each.value, "schema_grants", [])
  schema_objects_grants     = lookup(each.value, "schema_objects_grants", {})
}

module "snowflake_schema" {
  for_each = var.schemas

  source  = "getindata/schema/snowflake"
  version = "3.1.1"

  context_templates = var.context_templates

  name = each.key
  name_scheme = merge({
    uppercase = var.name_scheme.uppercase
    extra_values = {
      database = var.name
    } },
    lookup(each.value, "name_scheme", {})
  )

  is_transient        = each.value.is_transient
  with_managed_access = each.value.with_managed_access
  comment             = each.value.comment
  database            = snowflake_database.this.name

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
}

resource "snowflake_grant_ownership" "database_ownership" {
  count = var.database_ownership_grant != null ? 1 : 0

  account_role_name   = var.database_ownership_grant
  outbound_privileges = "COPY"
  on {
    object_type = "DATABASE"
    object_name = snowflake_database.this.name
  }

  # In order to create all resources before transferring ownership
  depends_on = [
    module.snowflake_default_role,
    module.snowflake_custom_role,
    module.snowflake_schema,
  ]
}
