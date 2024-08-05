module "database" {
  source = "../../"

  name = "analytics"

  log_level            = "ERROR"
  create_default_roles = true
}
