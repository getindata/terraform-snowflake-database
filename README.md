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

- Creates Snowflake database
- Can create custom Snowflake database roles with role-to-role assignments
- Can create a set of default database roles to simplify access management:
  - `READONLY` - granted `USAGE` and `MONITOR` privileges on the database
  - `TRANSFORMER` - allows creating schemas and some Snowflake objects in them
  - `ADMIN` - full access, including database options like `data_retention_time_in_days`
- Can create number of schemas in the database with their specific stages and access roles
- Can create database ownership to specified account role

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

## BREAKING CHANGES IN v2.x.x

Due to breaking changes in Snowflake provider and additional code optimizations, **breaking changes** were introduced in `v2.0.0` version of this module.


List of code and variable (API) changes:

- Switched to `snowflake_database_role` module to leverage new `database_roles` mechanism
- database `default_roles` and `custom_roles` are now managed by `getindata/database_role/snowflake` module
- snowflake_database resource was updated to use newly introduced changes in Snowflake provider
- snowflake_schema resource was updated to use newly introduced changes in Snowflake provider
- variable `add_grants_to_existing_objects` was removed as it is no longer needed
- minimum Snowflake provider version is `0.90.0`


For more information, refer to [variables.tf](variables.tf), list of inputs below and Snowflake provider documentation

When upgrading from `v1.x`, expect most of the resources to be recreated - if recreation is impossible, then it is possible to import some existing resources.

## Breaking changes in v3.x of the module

Due to replacement of nulllabel (`context.tf`) with context provider, some **breaking changes** were introduced in `v3.0.0` version of this module.

List od code and variable (API) changes:

- Removed `context.tf` file (a single-file module with additional variables), which implied a removal of all its variables (except `name`):
  - `descriptor_formats`
  - `label_value_case`
  - `label_key_case`
  - `id_length_limit`
  - `regex_replace_chars`
  - `label_order`
  - `additional_tag_map`
  - `tags`
  - `labels_as_tags`
  - `attributes`
  - `delimiter`
  - `stage`
  - `environment`
  - `tenant`
  - `namespace`
  - `enabled`
  - `context`
- Remove support `enabled` flag - that might cause some backward compatibility issues with terraform state (please take into account that proper `move` clauses were added to minimize the impact), but proceed with caution
- Additional `context` provider configuration
- New variables were added, to allow naming configuration via `context` provider:
  - `context_templates`
  - `name_schema`
  - `drop_public_schema_on_creation` which is `true` by default

<!-- BEGIN_TF_DOCS -->




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_catalog"></a> [catalog](#input\_catalog) | The database parameter that specifies the default catalog to use for Iceberg tables | `string` | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Specifies a comment for the database | `string` | `null` | no |
| <a name="input_context_templates"></a> [context\_templates](#input\_context\_templates) | Map of context templates used for naming conventions - this variable supersedes `naming_scheme.properties` and `naming_scheme.delimiter` configuration | `map(string)` | `{}` | no |
| <a name="input_create_default_roles"></a> [create\_default\_roles](#input\_create\_default\_roles) | Whether the default roles should be created | `bool` | `false` | no |
| <a name="input_data_retention_time_in_days"></a> [data\_retention\_time\_in\_days](#input\_data\_retention\_time\_in\_days) | Number of days for which Snowflake retains historical data for performing Time Travel actions (SELECT, CLONE, UNDROP) on the object. A value of 0 effectively disables Time Travel for the specified database, schema, or table | `number` | `null` | no |
| <a name="input_database_ownership_grant"></a> [database\_ownership\_grant](#input\_database\_ownership\_grant) | The name of the account role to which database privileges will be granted | `string` | `null` | no |
| <a name="input_default_ddl_collation"></a> [default\_ddl\_collation](#input\_default\_ddl\_collation) | Specifies a default collation specification for all schemas and tables added to the database. | `string` | `null` | no |
| <a name="input_drop_public_schema_on_creation"></a> [drop\_public\_schema\_on\_creation](#input\_drop\_public\_schema\_on\_creation) | Whether the `PUBLIC` schema should be dropped after the database creation | `bool` | `true` | no |
| <a name="input_enable_console_output"></a> [enable\_console\_output](#input\_enable\_console\_output) | If true, enables stdout/stderr fast path logging for anonymous stored procedures | `bool` | `null` | no |
| <a name="input_external_volume"></a> [external\_volume](#input\_external\_volume) | The database parameter that specifies the default external volume to use for Iceberg tables | `string` | `null` | no |
| <a name="input_is_transient"></a> [is\_transient](#input\_is\_transient) | Specifies a database as transient. Transient databases do not have a Fail-safe period so they do not incur additional storage costs once they leave Time Travel; however, this means they are also not protected by Fail-safe in the event of a data loss | `bool` | `null` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Specifies the severity level of messages that should be ingested and made available in the active event table. Valid options are: [TRACE DEBUG INFO WARN ERROR FATAL OFF] | `string` | `null` | no |
| <a name="input_max_data_extension_time_in_days"></a> [max\_data\_extension\_time\_in\_days](#input\_max\_data\_extension\_time\_in\_days) | Object parameter that specifies the maximum number of days for which Snowflake can extend the data retention period for tables in the database to prevent streams on the tables from becoming stale | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource | `string` | n/a | yes |
| <a name="input_name_scheme"></a> [name\_scheme](#input\_name\_scheme) | Naming scheme configuration for the resource. This configuration is used to generate names using context provider:<br>    - `properties` - list of properties to use when creating the name - is superseded by `var.context_templates`<br>    - `delimiter` - delimited used to create the name from `properties` - is superseded by `var.context_templates`<br>    - `context_template_name` - name of the context template used to create the name<br>    - `replace_chars_regex` - regex to use for replacing characters in property-values created by the provider - any characters that match the regex will be removed from the name<br>    - `extra_values` - map of extra label-value pairs, used to create a name | <pre>object({<br>    properties            = optional(list(string), ["environment", "name"])<br>    delimiter             = optional(string, "_")<br>    context_template_name = optional(string, "snowflake-database")<br>    replace_chars_regex   = optional(string, "[^a-zA-Z0-9_]")<br>    extra_values          = optional(map(string))<br>  })</pre> | `{}` | no |
| <a name="input_quoted_identifiers_ignore_case"></a> [quoted\_identifiers\_ignore\_case](#input\_quoted\_identifiers\_ignore\_case) | If true, the case of quoted identifiers is ignored | `bool` | `null` | no |
| <a name="input_replace_invalid_characters"></a> [replace\_invalid\_characters](#input\_replace\_invalid\_characters) | Specifies whether to replace invalid UTF-8 characters with the Unicode replacement character () in query results for an Iceberg table | `bool` | `null` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Roles created in the database scope | <pre>map(object({<br>    name_scheme = optional(object({<br>      properties            = optional(list(string))<br>      delimiter             = optional(string)<br>      context_template_name = optional(string)<br>      replace_chars_regex   = optional(string)<br>      extra_labels          = optional(map(string))<br>    }))<br>    comment              = optional(string)<br>    role_ownership_grant = optional(string)<br>    granted_roles        = optional(list(string))<br>    granted_to_roles     = optional(list(string))<br>    granted_to_users     = optional(list(string))<br>    database_grants = optional(object({<br>      all_privileges    = optional(bool)<br>      with_grant_option = optional(bool, false)<br>      privileges        = optional(list(string), null)<br>    }))<br>    schema_grants = optional(list(object({<br>      all_privileges             = optional(bool)<br>      with_grant_option          = optional(bool, false)<br>      privileges                 = optional(list(string), null)<br>      all_schemas_in_database    = optional(bool, false)<br>      future_schemas_in_database = optional(bool, false)<br>      schema_name                = optional(string, null)<br>    })))<br>    schema_objects_grants = optional(map(list(object({<br>      all_privileges    = optional(bool)<br>      with_grant_option = optional(bool)<br>      privileges        = optional(list(string), null)<br>      object_name       = optional(string)<br>      on_all            = optional(bool, false)<br>      schema_name       = optional(string)<br>      on_future         = optional(bool, false)<br>    }))), {})<br>  }))</pre> | `{}` | no |
| <a name="input_schemas"></a> [schemas](#input\_schemas) | Schemas to be created in the database | <pre>map(object({<br>    name_scheme = optional(object({<br>      properties            = optional(list(string))<br>      delimiter             = optional(string)<br>      context_template_name = optional(string)<br>      replace_chars_regex   = optional(string)<br>      extra_labels          = optional(map(string))<br>    }))<br>    skip_schema_creation                          = optional(bool, false)<br>    comment                                       = optional(string, null)<br>    data_retention_time_in_days                   = optional(number, null)<br>    max_data_extension_time_in_days               = optional(number, null)<br>    is_transient                                  = optional(bool, null)<br>    with_managed_access                           = optional(bool, null)<br>    external_volume                               = optional(string, null)<br>    catalog                                       = optional(string, null)<br>    replace_invalid_characters                    = optional(bool, null)<br>    default_ddl_collation                         = optional(string, null)<br>    storage_serialization_policy                  = optional(string, null)<br>    log_level                                     = optional(string, null)<br>    trace_level                                   = optional(string, null)<br>    suspend_task_after_num_failures               = optional(number, null)<br>    task_auto_retry_attempts                      = optional(number, null)<br>    user_task_managed_initial_warehouse_size      = optional(string, null)<br>    user_task_timeout_ms                          = optional(number, null)<br>    user_task_minimum_trigger_interval_in_seconds = optional(number, null)<br>    quoted_identifiers_ignore_case                = optional(bool, null)<br>    enable_console_output                         = optional(bool, null)<br>    pipe_execution_paused                         = optional(bool, null)<br>    create_default_roles                          = optional(bool)<br>    stages = optional(map(object({<br>      name_scheme = optional(object({<br>        properties            = optional(list(string))<br>        delimiter             = optional(string)<br>        context_template_name = optional(string)<br>        replace_chars_regex   = optional(string)<br>        extra_labels          = optional(map(string))<br>      }))<br>      aws_external_id      = optional(string)<br>      comment              = optional(string)<br>      copy_options         = optional(string)<br>      credentials          = optional(string)<br>      directory            = optional(string)<br>      encryption           = optional(string)<br>      file_format          = optional(string)<br>      snowflake_iam_user   = optional(string)<br>      storage_integration  = optional(string)<br>      url                  = optional(string)<br>      create_default_roles = optional(bool)<br>      roles = optional(map(object({<br>        name_scheme = optional(object({<br>          properties            = optional(list(string))<br>          delimiter             = optional(string)<br>          context_template_name = optional(string)<br>          replace_chars_regex   = optional(string)<br>          extra_labels          = optional(map(string))<br>        }))<br>        with_grant_option         = optional(bool)<br>        granted_to_roles          = optional(list(string))<br>        granted_to_database_roles = optional(list(string))<br>        granted_database_roles    = optional(list(string))<br>        stage_grants              = optional(list(string))<br>        all_privileges            = optional(bool)<br>      })), {})<br>    })), {})<br>    roles = optional(map(object({<br>      name_scheme = optional(object({<br>        properties            = optional(list(string))<br>        delimiter             = optional(string)<br>        context_template_name = optional(string)<br>        replace_chars_regex   = optional(string)<br>        extra_labels          = optional(map(string))<br>      }))<br>      comment                   = optional(string)<br>      granted_to_roles          = optional(list(string))<br>      granted_to_database_roles = optional(list(string))<br>      granted_database_roles    = optional(list(string))<br>      schema_grants = optional(list(object({<br>        all_privileges    = optional(bool)<br>        with_grant_option = optional(bool, false)<br>        privileges        = optional(list(string), null)<br>      })))<br>      schema_objects_grants = optional(map(list(object({<br>        all_privileges    = optional(bool)<br>        with_grant_option = optional(bool)<br>        privileges        = optional(list(string), null)<br>        object_name       = optional(string)<br>        on_all            = optional(bool, false)<br>        on_future         = optional(bool, false)<br>      }))), {})<br>    })), {})<br>  }))</pre> | `{}` | no |
| <a name="input_storage_serialization_policy"></a> [storage\_serialization\_policy](#input\_storage\_serialization\_policy) | The storage serialization policy for Iceberg tables that use Snowflake as the catalog. Valid options are: [COMPATIBLE OPTIMIZED] | `string` | `null` | no |
| <a name="input_suspend_task_after_num_failures"></a> [suspend\_task\_after\_num\_failures](#input\_suspend\_task\_after\_num\_failures) | How many times a task must fail in a row before it is automatically suspended. 0 disables auto-suspending | `number` | `null` | no |
| <a name="input_task_auto_retry_attempts"></a> [task\_auto\_retry\_attempts](#input\_task\_auto\_retry\_attempts) | Maximum automatic retries allowed for a user task | `number` | `null` | no |
| <a name="input_trace_level"></a> [trace\_level](#input\_trace\_level) | Controls how trace events are ingested into the event table. Valid options are: [ALWAYS ON\_EVENT OFF] | `string` | `null` | no |
| <a name="input_user_task_managed_initial_warehouse_size"></a> [user\_task\_managed\_initial\_warehouse\_size](#input\_user\_task\_managed\_initial\_warehouse\_size) | The initial size of warehouse to use for managed warehouses in the absence of history | `string` | `null` | no |
| <a name="input_user_task_minimum_trigger_interval_in_seconds"></a> [user\_task\_minimum\_trigger\_interval\_in\_seconds](#input\_user\_task\_minimum\_trigger\_interval\_in\_seconds) | Minimum amount of time between Triggered Task executions in seconds | `number` | `null` | no |
| <a name="input_user_task_timeout_ms"></a> [user\_task\_timeout\_ms](#input\_user\_task\_timeout\_ms) | User task execution timeout in milliseconds | `number` | `null` | no |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_roles_deep_merge"></a> [roles\_deep\_merge](#module\_roles\_deep\_merge) | Invicton-Labs/deepmerge/null | 0.1.5 |
| <a name="module_snowflake_custom_role"></a> [snowflake\_custom\_role](#module\_snowflake\_custom\_role) | getindata/database-role/snowflake | 2.0.1 |
| <a name="module_snowflake_default_role"></a> [snowflake\_default\_role](#module\_snowflake\_default\_role) | getindata/database-role/snowflake | 2.0.1 |
| <a name="module_snowflake_schema"></a> [snowflake\_schema](#module\_snowflake\_schema) | getindata/schema/snowflake | 3.0.0 |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_catalog"></a> [catalog](#output\_catalog) | The database parameter that specifies the default catalog to use for Iceberg tables |
| <a name="output_data_retention_time_in_days"></a> [data\_retention\_time\_in\_days](#output\_data\_retention\_time\_in\_days) | Data retention days for the database |
| <a name="output_database_ownership_grant"></a> [database\_ownership\_grant](#output\_database\_ownership\_grant) | The name of the account role to which database ownership will be granted |
| <a name="output_database_roles"></a> [database\_roles](#output\_database\_roles) | Snowflake Database roles |
| <a name="output_default_ddl_collation"></a> [default\_ddl\_collation](#output\_default\_ddl\_collation) | Specifies a default collation specification for all schemas and tables added to the database. |
| <a name="output_enable_console_output"></a> [enable\_console\_output](#output\_enable\_console\_output) | If true, enables stdout/stderr fast path logging for anonymous stored procedures |
| <a name="output_external_volume"></a> [external\_volume](#output\_external\_volume) | The database parameter that specifies the default external volume to use for Iceberg tables |
| <a name="output_is_transient"></a> [is\_transient](#output\_is\_transient) | Specifies a database as transient. Transient databases do not have a Fail-safe period so they do not incur additional storage costs once they leave Time Travel; however, this means they are also not protected by Fail-safe in the event of a data loss |
| <a name="output_log_level"></a> [log\_level](#output\_log\_level) | Specifies the severity level of messages that should be ingested and made available in the active event table. Valid options are: [TRACE DEBUG INFO WARN ERROR FATAL OFF] |
| <a name="output_max_data_extension_time_in_days"></a> [max\_data\_extension\_time\_in\_days](#output\_max\_data\_extension\_time\_in\_days) | Object parameter that specifies the maximum number of days for which Snowflake can extend the data retention period for tables in the database to prevent streams on the tables from becoming stale |
| <a name="output_name"></a> [name](#output\_name) | Name of the database |
| <a name="output_quoted_identifiers_ignore_case"></a> [quoted\_identifiers\_ignore\_case](#output\_quoted\_identifiers\_ignore\_case) | If true, the case of quoted identifiers is ignored |
| <a name="output_replace_invalid_characters"></a> [replace\_invalid\_characters](#output\_replace\_invalid\_characters) | Specifies whether to replace invalid UTF-8 characters with the Unicode replacement character () in query results for an Iceberg table |
| <a name="output_schemas"></a> [schemas](#output\_schemas) | This database schemas |
| <a name="output_storage_serialization_policy"></a> [storage\_serialization\_policy](#output\_storage\_serialization\_policy) | The storage serialization policy for Iceberg tables that use Snowflake as the catalog. Valid options are: [COMPATIBLE OPTIMIZED] |
| <a name="output_suspend_task_after_num_failures"></a> [suspend\_task\_after\_num\_failures](#output\_suspend\_task\_after\_num\_failures) | How many times a task must fail in a row before it is automatically suspended. 0 disables auto-suspending |
| <a name="output_task_auto_retry_attempts"></a> [task\_auto\_retry\_attempts](#output\_task\_auto\_retry\_attempts) | Maximum automatic retries allowed for a user task |
| <a name="output_trace_level"></a> [trace\_level](#output\_trace\_level) | Controls how trace events are ingested into the event table. Valid options are: [ALWAYS ON\_EVENT OFF] |
| <a name="output_user_task_managed_initial_warehouse_size"></a> [user\_task\_managed\_initial\_warehouse\_size](#output\_user\_task\_managed\_initial\_warehouse\_size) | The initial size of warehouse to use for managed warehouses in the absence of history |
| <a name="output_user_task_minimum_trigger_interval_in_seconds"></a> [user\_task\_minimum\_trigger\_interval\_in\_seconds](#output\_user\_task\_minimum\_trigger\_interval\_in\_seconds) | Minimum amount of time between Triggered Task executions in seconds |
| <a name="output_user_task_timeout_ms"></a> [user\_task\_timeout\_ms](#output\_user\_task\_timeout\_ms) | User task execution timeout in milliseconds |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_context"></a> [context](#provider\_context) | >=0.4.0 |
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | ~> 0.95 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_context"></a> [context](#requirement\_context) | >=0.4.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | ~> 0.95 |

## Resources

| Name | Type |
|------|------|
| [snowflake_database.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/database) | resource |
| [snowflake_grant_ownership.database_ownership](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/grant_ownership) | resource |
| [context_label.this](https://registry.terraform.io/providers/cloudposse/context/latest/docs/data-sources/label) | data source |
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
