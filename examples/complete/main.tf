resource "snowflake_user" "dbt" {
  name       = "DBT user"
  login_name = "dbt_user"
  comment    = "DBT user."
}

resource "snowflake_account_role" "admin_role" {
  name = "admin"
}

resource "snowflake_account_role" "dev_role" {
  name = "dev"
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
