variable "descriptor_name" {
  description = "Name of the descriptor used to form a resource name"
  type        = string
  default     = "snowflake-database"
}

variable "comment" {
  description = "Specifies a comment for the database"
  type        = string
  default     = null
}

variable "data_retention_time_in_days" {
  description = "Number of days for which Snowflake retains historical data for performing Time Travel actions (SELECT, CLONE, UNDROP) on the object. A value of 0 effectively disables Time Travel for the specified database, schema, or table"
  type        = number
  default     = null
}

variable "max_data_extension_time_in_days" {
  description = "Object parameter that specifies the maximum number of days for which Snowflake can extend the data retention period for tables in the database to prevent streams on the tables from becoming stale"
  type        = number
  default     = null
}

variable "is_transient" {
  description = "Specifies a database as transient. Transient databases do not have a Fail-safe period so they do not incur additional storage costs once they leave Time Travel; however, this means they are also not protected by Fail-safe in the event of a data loss"
  type        = bool
  default     = null
}

variable "external_volume" {
  description = "The database parameter that specifies the default external volume to use for Iceberg tables"
  type        = string
  default     = null
}

variable "catalog" {
  description = "The database parameter that specifies the default catalog to use for Iceberg tables"
  type        = string
  default     = null
}

variable "replace_invalid_characters" {
  description = "Specifies whether to replace invalid UTF-8 characters with the Unicode replacement character () in query results for an Iceberg table"
  type        = bool
  default     = null
}

variable "default_ddl_collation" {
  description = "Specifies a default collation specification for all schemas and tables added to the database."
  type        = string
  default     = null
}

variable "storage_serialization_policy" {
  description = "The storage serialization policy for Iceberg tables that use Snowflake as the catalog. Valid options are: [COMPATIBLE OPTIMIZED]"
  type        = string
  default     = null
}

variable "log_level" {
  description = "Specifies the severity level of messages that should be ingested and made available in the active event table. Valid options are: [TRACE DEBUG INFO WARN ERROR FATAL OFF]"
  type        = string
  default     = null
}

variable "trace_level" {
  description = "Controls how trace events are ingested into the event table. Valid options are: [ALWAYS ON_EVENT OFF]"
  type        = string
  default     = null
}

variable "suspend_task_after_num_failures" {
  description = "How many times a task must fail in a row before it is automatically suspended. 0 disables auto-suspending"
  type        = number
  default     = null
}

variable "task_auto_retry_attempts" {
  description = "Maximum automatic retries allowed for a user task"
  type        = number
  default     = null
}

variable "user_task_managed_initial_warehouse_size" {
  description = "The initial size of warehouse to use for managed warehouses in the absence of history"
  type        = string
  default     = null
}

variable "user_task_minimum_trigger_interval_in_seconds" {
  description = "Minimum amount of time between Triggered Task executions in seconds"
  type        = number
  default     = null
}

variable "user_task_timeout_ms" {
  description = "User task execution timeout in milliseconds"
  type        = number
  default     = null
}

variable "quoted_identifiers_ignore_case" {
  description = "If true, the case of quoted identifiers is ignored"
  type        = bool
  default     = null
}

variable "enable_console_output" {
  description = "If true, enables stdout/stderr fast path logging for anonymous stored procedures"
  type        = bool
  default     = null
}

variable "create_default_roles" {
  description = "Whether the default roles should be created"
  type        = bool
  default     = false
}

variable "roles" {
  description = "Roles created in the database scope"
  type = map(object({
    enabled              = optional(bool, true)
    descriptor_name      = optional(string, "snowflake-database-role")
    comment              = optional(string)
    role_ownership_grant = optional(string)
    granted_roles        = optional(list(string))
    granted_to_roles     = optional(list(string))
    granted_to_users     = optional(list(string))
    database_grants = optional(object({
      all_privileges    = optional(bool)
      with_grant_option = optional(bool, false)
      privileges        = optional(list(string), null)
    }))
    schema_grants = optional(list(object({
      all_privileges             = optional(bool)
      with_grant_option          = optional(bool, false)
      privileges                 = optional(list(string), null)
      all_schemas_in_database    = optional(bool, false)
      future_schemas_in_database = optional(bool, false)
      schema_name                = optional(string, null)
    })))
    schema_objects_grants = optional(map(list(object({
      all_privileges    = optional(bool)
      with_grant_option = optional(bool)
      privileges        = optional(list(string), null)
      object_name       = optional(string)
      on_all            = optional(bool, false)
      schema_name       = optional(string)
      on_future         = optional(bool, false)
    }))), {})
  }))
  default = {}
}

variable "schemas" {
  description = "Schemas to be created in the database"
  type = map(object({
    enabled                                       = optional(bool, true)
    skip_schema_creation                          = optional(bool, false)
    descriptor_name                               = optional(string, "snowflake-schema")
    comment                                       = optional(string, null)
    data_retention_time_in_days                   = optional(number, null)
    max_data_extension_time_in_days               = optional(number, null)
    is_transient                                  = optional(bool, null)
    with_managed_access                           = optional(bool, null)
    external_volume                               = optional(string, null)
    catalog                                       = optional(string, null)
    replace_invalid_characters                    = optional(bool, null)
    default_ddl_collation                         = optional(string, null)
    storage_serialization_policy                  = optional(string, null)
    log_level                                     = optional(string, null)
    trace_level                                   = optional(string, null)
    suspend_task_after_num_failures               = optional(number, null)
    task_auto_retry_attempts                      = optional(number, null)
    user_task_managed_initial_warehouse_size      = optional(string, null)
    user_task_timeout_ms                          = optional(number, null)
    user_task_minimum_trigger_interval_in_seconds = optional(number, null)
    quoted_identifiers_ignore_case                = optional(bool, null)
    enable_console_output                         = optional(bool, null)
    pipe_execution_paused                         = optional(bool, null)
    create_default_roles                          = optional(bool)
    stages = optional(map(object({
      enabled              = optional(bool, true)
      descriptor_name      = optional(string, "snowflake-stage")
      aws_external_id      = optional(string)
      comment              = optional(string)
      copy_options         = optional(string)
      credentials          = optional(string)
      directory            = optional(string)
      encryption           = optional(string)
      file_format          = optional(string)
      snowflake_iam_user   = optional(string)
      storage_integration  = optional(string)
      url                  = optional(string)
      create_default_roles = optional(bool)
      roles = optional(map(object({
        enabled                   = optional(bool, true)
        descriptor_name           = optional(string, "snowflake-database-role")
        with_grant_option         = optional(bool)
        granted_to_roles          = optional(list(string))
        granted_to_database_roles = optional(list(string))
        granted_database_roles    = optional(list(string))
        stage_grants              = optional(list(string))
        all_privileges            = optional(bool)
        on_all                    = optional(bool, false)
        schema_name               = optional(string)
        on_future                 = optional(bool, false)
      })), {})
    })), {})
    roles = optional(map(object({
      enabled                   = optional(bool, true)
      descriptor_name           = optional(string, "snowflake-database-role")
      comment                   = optional(string)
      granted_to_roles          = optional(list(string))
      granted_to_database_roles = optional(list(string))
      granted_database_roles    = optional(list(string))
      database_grants = optional(object({
        all_privileges    = optional(bool)
        with_grant_option = optional(bool, false)
        privileges        = optional(list(string), null)
      }))
      schema_grants = optional(list(object({
        all_privileges             = optional(bool)
        with_grant_option          = optional(bool, false)
        privileges                 = optional(list(string), null)
        all_schemas_in_database    = optional(bool, false)
        future_schemas_in_database = optional(bool, false)
        schema_name                = optional(string, null)
      })))
      schema_objects_grants = optional(map(list(object({
        all_privileges    = optional(bool)
        with_grant_option = optional(bool)
        privileges        = optional(list(string), null)
        object_name       = optional(string)
        on_all            = optional(bool, false)
        schema_name       = optional(string)
        on_future         = optional(bool, false)
      }))), {})
    })), {})
  }))
  default = {}
}
