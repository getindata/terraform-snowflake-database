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
  default     = 1
}

variable "is_transient" {
  description = " Specifies a database as transient. Transient databases do not have a Fail-safe period so they do not incur additional storage costs once they leave Time Travel; however, this means they are also not protected by Fail-safe in the event of a data loss"
  type        = bool
  default     = false
}

variable "from_database" {
  description = "Specify a database to create a clone from"
  type        = string
  default     = null
}

variable "from_replica" {
  description = "Specify a fully-qualified path to a database to create a replica from"
  type        = string
  default     = null
}

variable "from_share" {
  description = "Specify a provider and a share in this map to create a database from a share"
  type = object({
    provider = string
    share    = string
  })
  default = null
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
    comment              = optional(string)
    role_ownership_grant = optional(string)
    granted_roles        = optional(list(string))
    granted_to_roles     = optional(list(string))
    granted_to_users     = optional(list(string))
    database_grants      = optional(list(string))
    schema_grants        = optional(list(string))
  }))
  default = {}
}

variable "schemas" {
  description = "Schemas to be created in the database"
  type = map(object({
    descriptor_name      = optional(string, "snowflake-schema")
    comment              = optional(string)
    data_retention_days  = optional(number, 1)
    is_transient         = optional(bool, false)
    is_managed           = optional(bool, false)
    create_default_roles = optional(bool)
    roles = optional(map(object({
      enabled                  = optional(bool, true)
      comment                  = optional(string)
      role_ownership_grant     = optional(string)
      granted_roles            = optional(list(string))
      granted_to_roles         = optional(list(string))
      granted_to_users         = optional(list(string))
      schema_grants            = optional(list(string))
      table_grants             = optional(list(string))
      external_table_grants    = optional(list(string))
      view_grants              = optional(list(string))
      materialized_view_grants = optional(list(string))
      file_format_grants       = optional(list(string))
      function_grants          = optional(list(string))
      stage_grants             = optional(list(string))
      task_grants              = optional(list(string))
      procedure_grants         = optional(list(string))
      sequence_grants          = optional(list(string))
      stream_grants            = optional(list(string))
    })), {})
  }))
  default = {}
}
