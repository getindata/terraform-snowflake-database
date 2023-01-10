output "name" {
  description = "Name of the database"
  value       = one(snowflake_database.this[*].name)
}

output "data_retention_time_in_days" {
  description = "Data retention days for the database"
  value       = one(snowflake_database.this[*].data_retention_time_in_days)
}

output "is_transient" {
  description = "Is databse transient"
  value       = one(snowflake_database.this[*].is_transient)
}

output "roles" {
  description = "Snowflake Database roles"
  value       = local.roles
}

output "schemas" {
  description = "This database schemas"
  value       = module.snowflake_schema
}
