output "name" {
  description = "Name of the database"
  value       = one(snowflake_database.this[*].name)
}

output "data_retention_time_in_days" {
  description = "Data retention days for the database"
  value       = one(snowflake_database.this[*].data_retention_time_in_days)
}

output "max_data_extension_time_in_days" {
  description = "Object parameter that specifies the maximum number of days for which Snowflake can extend the data retention period for tables in the database to prevent streams on the tables from becoming stale"
  value       = one(snowflake_database.this[*].max_data_extension_time_in_days)
}

output "is_transient" {
  description = "Specifies a database as transient. Transient databases do not have a Fail-safe period so they do not incur additional storage costs once they leave Time Travel; however, this means they are also not protected by Fail-safe in the event of a data loss"
  value       = one(snowflake_database.this[*].is_transient)
}

output "external_volume" {
  description = "The database parameter that specifies the default external volume to use for Iceberg tables"
  value       = one(snowflake_database.this[*].external_volume)
}

output "catalog" {
  description = "The database parameter that specifies the default catalog to use for Iceberg tables"
  value       = one(snowflake_database.this[*].catalog)
}

output "replace_invalid_characters" {
  description = "Specifies whether to replace invalid UTF-8 characters with the Unicode replacement character () in query results for an Iceberg table"
  value       = one(snowflake_database.this[*].replace_invalid_characters)
}

output "default_ddl_collation" {
  description = "Specifies a default collation specification for all schemas and tables added to the database."
  value       = one(snowflake_database.this[*].default_ddl_collation)
}

output "storage_serialization_policy" {
  description = "The storage serialization policy for Iceberg tables that use Snowflake as the catalog. Valid options are: [COMPATIBLE OPTIMIZED]"
  value       = one(snowflake_database.this[*].storage_serialization_policy)
}

output "log_level" {
  description = "Specifies the severity level of messages that should be ingested and made available in the active event table. Valid options are: [TRACE DEBUG INFO WARN ERROR FATAL OFF]"
  value       = one(snowflake_database.this[*].log_level)
}

output "trace_level" {
  description = "Controls how trace events are ingested into the event table. Valid options are: [ALWAYS ON_EVENT OFF]"
  value       = one(snowflake_database.this[*].trace_level)
}

output "suspend_task_after_num_failures" {
  description = "How many times a task must fail in a row before it is automatically suspended. 0 disables auto-suspending"
  value       = one(snowflake_database.this[*].suspend_task_after_num_failures)
}

output "task_auto_retry_attempts" {
  description = "Maximum automatic retries allowed for a user task"
  value       = one(snowflake_database.this[*].task_auto_retry_attempts)
}

output "user_task_managed_initial_warehouse_size" {
  description = "The initial size of warehouse to use for managed warehouses in the absence of history"
  value       = one(snowflake_database.this[*].user_task_managed_initial_warehouse_size)
}

output "user_task_minimum_trigger_interval_in_seconds" {
  description = "Minimum amount of time between Triggered Task executions in seconds"
  value       = one(snowflake_database.this[*].user_task_minimum_trigger_interval_in_seconds)
}

output "user_task_timeout_ms" {
  description = "User task execution timeout in milliseconds"
  value       = one(snowflake_database.this[*].user_task_timeout_ms)
}

output "quoted_identifiers_ignore_case" {
  description = "If true, the case of quoted identifiers is ignored"
  value       = one(snowflake_database.this[*].quoted_identifiers_ignore_case)
}

output "enable_console_output" {
  description = "If true, enables stdout/stderr fast path logging for anonymous stored procedures"
  value       = one(snowflake_database.this[*].enable_console_output)
}

output "database_roles" {
  description = "Snowflake Database roles"
  value       = local.roles
}

output "schemas" {
  description = "This database schemas"
  value       = module.snowflake_schema
}

output "database_ownership_account_role_name" {
  description = "The fully qualified name of the account role to which database ownership will be granted"
  value       = one(snowflake_grant_ownership.database_ownership[*])
}
