context_templates = {
  snowflake-database               = "{{.environment}}_{{.name}}"
  snowflake-project-database       = "{{.environment}}_{{.project}}_{{.name}}"
  snowflake-database-database-role = "{{.name}}"
  snowflake-schema                 = "{{.name}}"
  snowflake-schema-database-role   = "{{.schema}}_{{.name}}"
}
