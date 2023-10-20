resource "snowflake_user" "dbt" {
  name       = "DBT user"
  login_name = "dbt_user"
  comment    = "DBT user."
}

module "snowflake_admin_role" {
  source  = "getindata/role/snowflake"
  version = "1.1.0"
  context = module.this.context
  name    = "admin"
}

module "snowflake_dev_role" {
  source  = "getindata/role/snowflake"
  version = "1.1.0"
  context = module.this.context
  name    = "dev"
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
      granted_to_roles = [module.snowflake_dev_role.name]
    }
    admin = {
      granted_to_roles = [module.snowflake_admin_role.name]
    }
  }

  schemas = {
    bronze = {
      stages = {
        example = {}
      }
      roles = {
        admin = {
          granted_to_roles = [module.snowflake_admin_role.name]
        }
        readonly = {
          granted_to_roles = [module.snowflake_dev_role.name]
        }
      }
    }
    silver = {
      roles = {
        admin = {
          granted_to_roles = [module.snowflake_admin_role.name]
        }
      }
    }
    gold = {
      roles = {
        admin = {
          granted_to_roles = [module.snowflake_admin_role.name]
        }
      }
    }
  }
}


module "dev_database" {
  source      = "../../"
  context     = module.this.context
  environment = "dev"

  name          = "analytics"
  from_database = module.prod_database.name
}
