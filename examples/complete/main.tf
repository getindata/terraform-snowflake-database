resource "snowflake_account_role" "admin_role" {
  name = "administrator"
}

resource "snowflake_account_role" "dev_role" {
  name = "developer"
}

module "prod_database" {
  source      = "../../"
  context     = module.this.context
  environment = "prod"

  name                        = "analytics"
  comment                     = "my database"
  data_retention_time_in_days = 1
  is_transient                = false

  create_default_roles = true

  database_ownership_account_role_name = snowflake_account_role.admin_role.name

  roles = {
    readonly = {
      granted_to_roles = [snowflake_account_role.dev_role.name]
    }
    transformer = {
      enabled = false
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
        transformer = {
          enabled = false
        }
      }
    }
    silver = {
      roles = {
        admin = {
          granted_to_roles = [snowflake_account_role.admin_role.name]
        }
        transformer = {
          enabled = false
        }
      }
    }
    gold = {
      roles = {
        admin = {
          granted_to_roles = [snowflake_account_role.admin_role.name]
        }
        transformer = {
          enabled = false
        }
      }
    }
  }
}
