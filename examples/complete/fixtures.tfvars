descriptor_formats = {
  snowflake-database-role = {
    labels = ["attributes", "name"]
    format = "%v_%v"
  }
  snowflake-database = {
    labels = ["environment", "name", "attributes"]
    format = "%v_%v_%v"
  }
  snowflake-schema = {
    labels = ["name", "attributes"]
    format = "%v_%v"
  }
  snowflake-stage = {
    labels = ["name", "attributes"]
    format = "%v_%v"
  }
}

tags = {
  Terraform = "True"
}
