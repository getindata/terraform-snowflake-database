# Complete Example

```terraform
resource "snowflake_user" "dbt" {
  name       = "DBT user"
  login_name = "dbt_user"
  comment    = "DBT user."
}

resource "snowflake_role" "admin" {
  name    = "ADMIN"
  comment = "Role for Snowflake Administrators"
}

resource "snowflake_role" "dev" {
  name    = "DEV"
  comment = "Role for Snowflake Developers"
}

resource "snowflake_database" "test" {
  name = "ANALYTICS_DB"
}

module "this_schema" {
  source = "../../"
  context = module.this.context

  name     = "raw"
  database = snowflake_database.test.name

  create_default_roles = true
  roles = {
    admin = {
      granted_to_roles = [snowflake_role.admin.name]
    }
    readwrite = {
      granted_to_users = [snowflake_user.dbt.name]
    }
    readonly = {
      granted_to_roles = [snowflake_role.dev.name]
    }
    read_classified = {
      enabled = false
    }
    custom_access = {
      granted_to_users = [snowflake_user.dbt.name]
    }
  }
}
```

## Usage
Populate `.env` file with Snowflake credentials and make sure it's sourced to your shell.

```
terraform init
terraform plan -var-file fixtures.tfvars -out tfplan
terraform apply tfplan
```
