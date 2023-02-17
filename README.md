# Snowflake Database Terraform Module
![Snowflake](https://img.shields.io/badge/-SNOWFLAKE-249edc?style=for-the-badge&logo=snowflake&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

![License](https://badgen.net/github/license/getindata/terraform-snowflake-database/)
![Release](https://badgen.net/github/release/getindata/terraform-snowflake-database/)

<p align="center">
  <img height="150" src="https://getindata.com/img/logo.svg">
  <h3 align="center">We help companies turn their data into assets</h3>
</p>

---

Terraform module for Snowflake database management.

* Creates Snowflake database
* Can create custom Snowflake roles with role-to-role, role-to-user assignments
* Can create a set of default roles to simplify access management:
    * `READONLY` - granted `USAGE` privilege on the database
    * `TRANSFORMER` - allows creating schemas and some Snowflake objects in them
    * `ADMIN` - full access, including database options like `data_retention_time_in_days`
* Can create number of schemas in the database with their specific access roles

## USAGE

```terraform
module "snowflake_database" {
  source = "getindata/database/snowflake"
  # version  = "x.x.x"
  name = "MY_DB"

  is_transient                = false
  data_retention_time_in_days = 1

  create_default_roles = true
}
```

## EXAMPLES

- [Simple](examples/simple) - Basic usage of the module
- [Complete](examples/complete) - Advanced usage of the module

<!-- BEGIN_TF_DOCS -->




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Specifies a comment for the database | `string` | `null` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_create_default_roles"></a> [create\_default\_roles](#input\_create\_default\_roles) | Whether the default roles should be created | `bool` | `false` | no |
| <a name="input_data_retention_time_in_days"></a> [data\_retention\_time\_in\_days](#input\_data\_retention\_time\_in\_days) | Number of days for which Snowflake retains historical data for performing Time Travel actions (SELECT, CLONE, UNDROP) on the object. A value of 0 effectively disables Time Travel for the specified database, schema, or table | `number` | `1` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_descriptor_name"></a> [descriptor\_name](#input\_descriptor\_name) | Name of the descriptor used to form a resource name | `string` | `"snowflake-database"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_from_database"></a> [from\_database](#input\_from\_database) | Specify a database to create a clone from | `string` | `null` | no |
| <a name="input_from_replica"></a> [from\_replica](#input\_from\_replica) | Specify a fully-qualified path to a database to create a replica from | `string` | `null` | no |
| <a name="input_from_share"></a> [from\_share](#input\_from\_share) | Specify a provider and a share in this map to create a database from a share | <pre>object({<br>    provider = string<br>    share    = string<br>  })</pre> | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_is_transient"></a> [is\_transient](#input\_is\_transient) | Specifies a database as transient. Transient databases do not have a Fail-safe period so they do not incur additional storage costs once they leave Time Travel; however, this means they are also not protected by Fail-safe in the event of a data loss | `bool` | `false` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Roles created in the database scope | <pre>map(object({<br>    enabled              = optional(bool, true)<br>    descriptor_name      = optional(string, "snowflake-role")<br>    comment              = optional(string)<br>    role_ownership_grant = optional(string)<br>    granted_roles        = optional(list(string))<br>    granted_to_roles     = optional(list(string))<br>    granted_to_users     = optional(list(string))<br>    database_grants      = optional(list(string))<br>    schema_grants        = optional(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_schemas"></a> [schemas](#input\_schemas) | Schemas to be created in the database | <pre>map(object({<br>    enabled              = optional(bool, true)<br>    skip_schema_creation = optional(bool, false)<br>    descriptor_name      = optional(string, "snowflake-schema")<br>    comment              = optional(string)<br>    data_retention_days  = optional(number, 1)<br>    is_transient         = optional(bool, false)<br>    is_managed           = optional(bool, false)<br>    stages = optional(map(object({<br>      enabled              = optional(bool, true)<br>      descriptor_name      = optional(string, "snowflake-stage")<br>      aws_external_id      = optional(string)<br>      comment              = optional(string)<br>      copy_options         = optional(string)<br>      credentials          = optional(string)<br>      directory            = optional(string)<br>      encryption           = optional(string)<br>      file_format          = optional(string)<br>      snowflake_iam_user   = optional(string)<br>      storage_integration  = optional(string)<br>      url                  = optional(string)<br>      create_default_roles = optional(bool)<br>      roles = optional(map(object({<br>        enabled              = optional(bool, true)<br>        descriptor_name      = optional(string, "snowflake-role")<br>        comment              = optional(string)<br>        role_ownership_grant = optional(string)<br>        granted_roles        = optional(list(string))<br>        granted_to_roles     = optional(list(string))<br>        granted_to_users     = optional(list(string))<br>        stage_grants         = optional(list(string))<br>      })), {})<br>    })), {})<br>    create_default_roles = optional(bool)<br>    roles = optional(map(object({<br>      enabled                  = optional(bool, true)<br>      descriptor_name          = optional(string, "snowflake-role")<br>      comment                  = optional(string)<br>      role_ownership_grant     = optional(string)<br>      granted_roles            = optional(list(string))<br>      granted_to_roles         = optional(list(string))<br>      granted_to_users         = optional(list(string))<br>      schema_grants            = optional(list(string))<br>      table_grants             = optional(list(string))<br>      external_table_grants    = optional(list(string))<br>      view_grants              = optional(list(string))<br>      materialized_view_grants = optional(list(string))<br>      file_format_grants       = optional(list(string))<br>      function_grants          = optional(list(string))<br>      stage_grants             = optional(list(string))<br>      task_grants              = optional(list(string))<br>      procedure_grants         = optional(list(string))<br>      sequence_grants          = optional(list(string))<br>      stream_grants            = optional(list(string))<br>    })), {})<br>  }))</pre> | `{}` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_database_label"></a> [database\_label](#module\_database\_label) | cloudposse/label/null | 0.25.0 |
| <a name="module_roles_deep_merge"></a> [roles\_deep\_merge](#module\_roles\_deep\_merge) | Invicton-Labs/deepmerge/null | 0.1.5 |
| <a name="module_snowflake_custom_role"></a> [snowflake\_custom\_role](#module\_snowflake\_custom\_role) | getindata/role/snowflake | 1.0.3 |
| <a name="module_snowflake_default_role"></a> [snowflake\_default\_role](#module\_snowflake\_default\_role) | getindata/role/snowflake | 1.0.3 |
| <a name="module_snowflake_schema"></a> [snowflake\_schema](#module\_snowflake\_schema) | getindata/schema/snowflake | 1.3.1 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_retention_time_in_days"></a> [data\_retention\_time\_in\_days](#output\_data\_retention\_time\_in\_days) | Data retention days for the database |
| <a name="output_is_transient"></a> [is\_transient](#output\_is\_transient) | Is databse transient |
| <a name="output_name"></a> [name](#output\_name) | Name of the database |
| <a name="output_roles"></a> [roles](#output\_roles) | Snowflake Database roles |
| <a name="output_schemas"></a> [schemas](#output\_schemas) | This database schemas |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | ~> 0.54 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | ~> 0.54 |

## Resources

| Name | Type |
|------|------|
| [snowflake_database.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/database) | resource |
| [snowflake_database_grant.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/database_grant) | resource |
| [snowflake_schema_grant.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/schema_grant) | resource |
<!-- END_TF_DOCS -->

## CONTRIBUTING

Contributions are very welcomed!

Start by reviewing [contribution guide](CONTRIBUTING.md) and our [code of conduct](CODE_OF_CONDUCT.md). After that, start coding and ship your changes by creating a new PR.

## LICENSE

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

## AUTHORS

<!--- Replace repository name -->
<a href="https://github.com/getindata/REPO_NAME/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=getindata/terraform-snowflake-database" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
