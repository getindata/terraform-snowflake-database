# Simple Example

```terraform
module "database" {
  source = "../../"

  name = "analytics"
}
```

## Usage
Populate `.env` file with Snowflake credentials and make sure it's sourced to your shell.

```
terraform init
terraform plan -out tfplan
terraform apply tfplan
```
