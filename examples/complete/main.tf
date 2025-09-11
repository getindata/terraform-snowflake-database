resource "snowflake_account_role" "admin_role" {
  name = "administrator"
}

resource "snowflake_account_role" "dev_role" {
  name = "developer"
}

module "database" {
  source = "../../"

  context_templates = var.context_templates

  name                        = "example_db"
  comment                     = "test database"
  data_retention_time_in_days = 1
  is_transient                = false

  create_default_roles     = true
  database_ownership_grant = snowflake_account_role.admin_role.name

  roles = {
    readonly = {
      granted_to_roles = [snowflake_account_role.dev_role.name]
    }
    admin = {
      granted_to_roles = [snowflake_account_role.admin_role.name]
    }
  }

  schemas = {
    bronze = {
      data_retention_time_in_days = 7
      comment                     = "my bronze schema"
      stages = {
        example = {
          comment = "my example stage"
          name_scheme = {
            uppercase = false
          }
        }
      }
      roles = {
        admin = {
          granted_to_roles = [snowflake_account_role.admin_role.name]
        }
        readonly = {
          granted_to_roles = [snowflake_account_role.dev_role.name]
          name_scheme = {
            uppercase = false
          }
        }
      }
    }
    silver = {
      roles = {
        admin = {
          granted_to_roles = [snowflake_account_role.admin_role.name]
        }
      }
    }
    gold = {
      roles = {
        admin = {
          granted_to_roles = [snowflake_account_role.admin_role.name]
        }
      }
    }
  }
}

# This configuration might be used with "Standard" Snowflake edition, where MATERIALIZED VIEWs are not supported.
module "project_database" {
  source = "../../"

  context_templates = var.context_templates

  name = "analytics"
  name_scheme = {
    context_template_name = "snowflake-project-database"
    extra_values = {
      project = "project"
    }
    uppercase = false
  }


  comment                     = "test database"
  data_retention_time_in_days = 1
  is_transient                = false

  create_default_roles     = true
  database_ownership_grant = snowflake_account_role.admin_role.name

  schemas = {
    test = {
      roles = {
        transformer = {
          schema_grants = [{
            privileges = [
              "CREATE TEMPORARY TABLE",
              "CREATE TAG",
              "CREATE PIPE",
              "CREATE PROCEDURE",
              "USAGE",
              "CREATE TABLE",
              "CREATE FILE FORMAT",
              "CREATE STAGE",
              "CREATE TASK",
              "CREATE FUNCTION",
              "CREATE EXTERNAL TABLE",
              "CREATE SEQUENCE",
              "CREATE VIEW",
              "CREATE STREAM"
            ]
          }]
          schema_objects_grants = {
            "MATERIALIZED VIEW" = []
          }
        }
      }
    }
  }
}
