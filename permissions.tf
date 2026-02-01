# Roles and Permissions
# Creates the Euno agent user role and grants necessary permissions

# Create the agent user role
resource "snowflake_role" "euno_agent_user" {
  name    = var.role_name
  comment = "Role for users to interact with the Euno AI agent"
}

# Grant the role to ACCOUNTADMIN
resource "snowflake_grant_account_role" "euno_agent_user_to_accountadmin" {
  role_name        = snowflake_role.euno_agent_user.name
  parent_role_name = "ACCOUNTADMIN"
}

# Grant CORTEX_USER database role to the agent user role and ACCOUNTADMIN
# Commented out due to provider bug - will grant manually if needed
# resource "snowflake_grant_database_role" "cortex_to_euno_role" {
#   database_role_name = "SNOWFLAKE.CORTEX_USER"
#   parent_role_name   = snowflake_role.euno_agent_user.name
# }

# Commented out due to provider bug - ACCOUNTADMIN already has access
# resource "snowflake_grant_database_role" "cortex_to_accountadmin" {
#   database_role_name = "SNOWFLAKE.CORTEX_USER"
#   parent_role_name   = "ACCOUNTADMIN"
# }

# Grant database usage
resource "snowflake_grant_privileges_to_account_role" "database_usage" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.intelligence.name
  }
}

# Grant schema usage
resource "snowflake_grant_privileges_to_account_role" "schema_usage" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema {
    schema_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}"
  }
}

# Grant warehouse usage
resource "snowflake_grant_privileges_to_account_role" "warehouse_usage" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = var.warehouse_name
  }
}

# Grant usage on API integration
resource "snowflake_grant_privileges_to_account_role" "api_integration_usage" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_account_object {
    object_type = "INTEGRATION"
    object_name = snowflake_api_integration.euno_mcp.name
  }
}

# Grant usage on all external functions
# We need to grant on each function individually
resource "snowflake_grant_privileges_to_account_role" "external_function_euno_instructions" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_external_function.euno_instructions.name}(VARIANT)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "external_function_count_resources" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_external_function.euno_count_resources.name}(VARIANT, VARIANT, VARIANT, VARIANT, VARIANT)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "external_function_fetch_single_resource" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_external_function.euno_fetch_single_resource.name}(VARIANT, VARIANT)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "external_function_find_resource_by_name" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_external_function.euno_find_resource_by_name.name}(VARIANT, VARIANT, VARIANT, VARIANT)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "external_function_find_resources_for_topic" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_external_function.euno_find_resources_for_topic.name}(VARIANT, VARIANT, VARIANT, VARIANT)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "external_function_get_upstream_lineage" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_external_function.euno_get_upstream_lineage.name}(VARIANT, VARIANT, VARIANT, VARIANT, VARIANT)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "external_function_resource_impact_analysis" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_external_function.euno_resource_impact_analysis.name}(VARIANT)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "external_function_search_resources" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_external_function.euno_search_resources.name}(VARIANT, VARIANT, VARIANT, VARIANT, VARIANT, VARIANT, VARIANT)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "external_function_documentation_search" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_external_function.euno_documentation_search.name}(VARIANT)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "external_function_documentation_get_full_document" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_external_function.euno_documentation_get_full_document.name}(VARIANT)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "external_function_documentation_get_surrounding_context" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_external_function.euno_documentation_get_surrounding_context.name}(VARIANT, VARIANT)"
  }
}

# Grant usage on all wrapper functions
resource "snowflake_grant_privileges_to_account_role" "wrapper_function_instructions" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_function.euno_instructions_wrapper.name}(NUMBER)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "wrapper_function_count_resources" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_function.euno_count_resources_wrapper.name}(STRING, STRING, STRING, STRING, STRING)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "wrapper_function_fetch_single_resource" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_function.euno_fetch_single_resource_wrapper.name}(STRING, STRING)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "wrapper_function_find_resource_by_name" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_function.euno_find_resource_by_name_wrapper.name}(STRING, STRING, STRING, STRING)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "wrapper_function_find_resources_for_topic" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_function.euno_find_resources_for_topic_wrapper.name}(STRING, STRING, STRING, STRING)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "wrapper_function_get_upstream_lineage" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_function.euno_get_upstream_lineage_wrapper.name}(STRING, STRING, STRING, STRING, STRING)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "wrapper_function_resource_impact_analysis" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_function.euno_resource_impact_analysis_wrapper.name}(STRING)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "wrapper_function_search_resources" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_function.euno_search_resources_wrapper.name}(STRING, STRING, STRING, STRING, STRING, STRING, STRING)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "wrapper_function_documentation_search" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_function.euno_documentation_search_wrapper.name}(STRING)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "wrapper_function_documentation_get_full_document" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_function.euno_documentation_get_full_document_wrapper.name}(STRING)"
  }
}

resource "snowflake_grant_privileges_to_account_role" "wrapper_function_documentation_get_surrounding_context" {
  account_role_name = snowflake_role.euno_agent_user.name
  privileges        = ["USAGE"]
  on_schema_object {
    object_type = "FUNCTION"
    object_name = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_function.euno_documentation_get_surrounding_context_wrapper.name}(STRING, NUMBER)"
  }
}

# Grant the role to specified users (if any)
resource "snowflake_grant_account_role" "grant_to_users" {
  for_each = toset(var.grant_role_to_users)

  role_name = snowflake_role.euno_agent_user.name
  user_name = each.value
}

# Note: Agent usage grant needs to be done via SQL after agent is created
# GRANT USAGE ON AGENT ${var.agent_name} TO ROLE ${var.role_name};
