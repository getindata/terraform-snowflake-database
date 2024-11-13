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
        }
      }
      roles = {
        admin = {
          granted_to_roles = [snowflake_account_role.admin_role.name]
        }
        readonly = {
          granted_to_roles = [snowflake_account_role.dev_role.name]
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

module "project_database" {
  source = "../../"

  context_templates = var.context_templates

  name = "analytics"
  name_scheme = {
    context_template_name = "snowflake-project-database"
    extra_values = {
      project = "project"
    }
  }
}
