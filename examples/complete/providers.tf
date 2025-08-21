provider "snowflake" {
  preview_features_enabled = [
    "snowflake_stage_resource",
  ]
}

provider "context" {
  properties = {
    "environment" = {}
    "name"        = {}
  }

  values = {
    environment = "dev"
  }
}
