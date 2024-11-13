provider "snowflake" {}

provider "context" {
  properties = {
    "environment" = {}
    "name"        = { required = true }
  }

  values = {
    environment = "dev"
  }
}
