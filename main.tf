# Use ACCOUNTADMIN role for setup
resource "snowflake_database" "intelligence" {
  name    = var.database_name
  comment = "Database for Snowflake Intelligence agents"
}

resource "snowflake_schema" "agents" {
  database = snowflake_database.intelligence.name
  name     = var.schema_name
  comment  = "Schema for Euno agent functions and definitions"
}

# Network rule for API Gateway
resource "snowflake_network_rule" "euno_api_gateway" {
  name       = var.network_rule_name
  database   = snowflake_database.intelligence.name
  schema     = snowflake_schema.agents.name
  mode       = "EGRESS"
  type       = "HOST_PORT"
  value_list = [var.api_gateway_host]
  comment    = "Network rule for Euno API Gateway"
}

# API Integration
resource "snowflake_api_integration" "euno_mcp" {
  name                 = var.api_integration_name
  api_provider         = "google_api_gateway"
  google_audience      = var.api_gateway_audience
  api_allowed_prefixes = ["${var.api_gateway_audience}/"]
  enabled              = true
  comment              = "API integration for Euno MCP external functions"
}

locals {
  api_base_url = "${var.api_gateway_audience}/mcp/endpoints"
  api_headers = {
    "api-key"    = var.euno_api_key
    "account-id" = var.euno_account_id
  }
}

# External Functions
resource "snowflake_external_function" "euno_instructions" {
  name     = "EUNO_INSTRUCTIONS"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arg {
    name = "page"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  null_input_behavior       = "CALLED ON NULL INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/euno_instructions"

  header {
    name  = "api-key"
    value = var.euno_api_key
  }

  header {
    name  = "account-id"
    value = var.euno_account_id
  }

  comment = "Get detailed instructions on using Euno MCP server"
}

resource "snowflake_external_function" "euno_count_resources" {
  name     = "EUNO_COUNT_RESOURCES"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arg {
    name = "query"
    type = "VARIANT"
  }

  arg {
    name = "reasoning"
    type = "VARIANT"
  }

  arg {
    name = "group_by_property"
    type = "VARIANT"
  }

  arg {
    name = "resource_relationship_schema"
    type = "VARIANT"
  }

  arg {
    name = "related_use_cases"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  null_input_behavior       = "CALLED ON NULL INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/count_resources"

  header {
    name  = "api-key"
    value = var.euno_api_key
  }

  header {
    name  = "account-id"
    value = var.euno_account_id
  }

  comment = "Count resources matching a query with optional grouping"
}

resource "snowflake_external_function" "euno_fetch_single_resource" {
  name     = "EUNO_FETCH_SINGLE_RESOURCE"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arg {
    name = "resource_uri"
    type = "VARIANT"
  }

  arg {
    name = "properties_to_fetch"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  null_input_behavior       = "CALLED ON NULL INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/fetch_single_resource"

  header {
    name  = "api-key"
    value = var.euno_api_key
  }

  header {
    name  = "account-id"
    value = var.euno_account_id
  }

  comment = "Retrieve a single resource by URI"
}

resource "snowflake_external_function" "euno_find_resource_by_name" {
  name     = "EUNO_FIND_RESOURCE_BY_NAME"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arg {
    name = "resource_name"
    type = "VARIANT"
  }

  arg {
    name = "reasoning"
    type = "VARIANT"
  }

  arg {
    name = "filter_by_resource_types"
    type = "VARIANT"
  }

  arg {
    name = "properties_to_return"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  null_input_behavior       = "CALLED ON NULL INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/find_resource_by_name"

  header {
    name  = "api-key"
    value = var.euno_api_key
  }

  header {
    name  = "account-id"
    value = var.euno_account_id
  }

  comment                   = "Find resources by name using similarity matching"
}

resource "snowflake_external_function" "euno_find_resources_for_topic" {
  name     = "EUNO_FIND_RESOURCES_FOR_TOPIC"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arg {
    name = "query_strings"
    type = "VARIANT"
  }

  arg {
    name = "reasoning"
    type = "VARIANT"
  }

  arg {
    name = "filter_by_resource_types"
    type = "VARIANT"
  }

  arg {
    name = "properties_to_return"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  null_input_behavior       = "CALLED ON NULL INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/find_resources_for_topic"

  header {
    name  = "api-key"
    value = var.euno_api_key
  }

  header {
    name  = "account-id"
    value = var.euno_account_id
  }

  comment                   = "Find resources related to a topic using semantic search"
}

resource "snowflake_external_function" "euno_get_upstream_lineage" {
  name     = "EUNO_GET_UPSTREAM_LINEAGE"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arg {
    name = "resource_uri"
    type = "VARIANT"
  }

  arg {
    name = "reasoning"
    type = "VARIANT"
  }

  arg {
    name = "properties_to_fetch"
    type = "VARIANT"
  }

  arg {
    name = "related_use_cases"
    type = "VARIANT"
  }

  arg {
    name = "filter_by_resource_types"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  null_input_behavior       = "CALLED ON NULL INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/get_upstream_lineage"

  header {
    name  = "api-key"
    value = var.euno_api_key
  }

  header {
    name  = "account-id"
    value = var.euno_account_id
  }

  comment                   = "Get upstream lineage/dependencies for a resource"
}

resource "snowflake_external_function" "euno_resource_impact_analysis" {
  name     = "EUNO_RESOURCE_IMPACT_ANALYSIS"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arg {
    name = "uri"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  null_input_behavior       = "CALLED ON NULL INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/resource_impact_analysis"

  header {
    name  = "api-key"
    value = var.euno_api_key
  }

  header {
    name  = "account-id"
    value = var.euno_account_id
  }

  comment                   = "Analyze downstream impact of changes to a resource"
}

resource "snowflake_external_function" "euno_search_resources" {
  name     = "EUNO_SEARCH_RESOURCES"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arg {
    name = "query"
    type = "VARIANT"
  }

  arg {
    name = "reasoning"
    type = "VARIANT"
  }

  arg {
    name = "resource_relationship_schema"
    type = "VARIANT"
  }

  arg {
    name = "related_use_cases"
    type = "VARIANT"
  }

  arg {
    name = "order_by_property"
    type = "VARIANT"
  }

  arg {
    name = "order_direction"
    type = "VARIANT"
  }

  arg {
    name = "properties_to_return"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  null_input_behavior       = "CALLED ON NULL INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/search_resources"

  header {
    name  = "api-key"
    value = var.euno_api_key
  }

  header {
    name  = "account-id"
    value = var.euno_account_id
  }

  comment                   = "Advanced search with EQL or natural language queries"
}

resource "snowflake_external_function" "euno_documentation_search" {
  name     = "EUNO_DOCUMENTATION_SEARCH"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arg {
    name = "query"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  null_input_behavior       = "CALLED ON NULL INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/documentation_search"

  header {
    name  = "api-key"
    value = var.euno_api_key
  }

  header {
    name  = "account-id"
    value = var.euno_account_id
  }

  comment                   = "Search Euno documentation"
}

resource "snowflake_external_function" "euno_documentation_get_full_document" {
  name     = "EUNO_DOCUMENTATION_GET_FULL_DOCUMENT"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arg {
    name = "url"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  null_input_behavior       = "CALLED ON NULL INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/documentation_get_full_document"

  header {
    name  = "api-key"
    value = var.euno_api_key
  }

  header {
    name  = "account-id"
    value = var.euno_account_id
  }

  comment                   = "Retrieve full documentation by URL"
}

resource "snowflake_external_function" "euno_documentation_get_surrounding_context" {
  name     = "EUNO_DOCUMENTATION_GET_SURROUNDING_CONTEXT"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arg {
    name = "chunk_id"
    type = "VARIANT"
  }

  arg {
    name = "window_size"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  null_input_behavior       = "CALLED ON NULL INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/documentation_get_surrounding_context"

  header {
    name  = "api-key"
    value = var.euno_api_key
  }

  header {
    name  = "account-id"
    value = var.euno_account_id
  }

  comment                   = "Get context around a documentation chunk"
}

# Wrapper functions, permissions, and agent SQL generation are defined in separate files:
# - wrapper_functions.tf: SQL wrapper functions for type safety
# - permissions.tf: Role creation and permission grants
# - agent.tf: Agent SQL generation (requires manual application due to provider limitations)
