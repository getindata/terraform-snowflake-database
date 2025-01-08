# Simple Example

This is a simple usage example of the module.

## Usage
Populate `.env` file with Snowflake credentials and make sure it's sourced to your shell.

```
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

<!-- BEGIN_TF_DOCS -->




## Inputs

No inputs.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_database"></a> [database](#module\_database) | ../../ | n/a |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database"></a> [database](#output\_database) | Database module outputs |

## Providers

No providers.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | >= 0.95 |

## Resources

No resources.
<!-- END_TF_DOCS -->
