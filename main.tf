terraform {
  required_version = ">= 1.5.0"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.98"
    }
  }
}

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
resource "snowflake_function" "euno_instructions" {
  name     = "euno_instructions"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "page"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  language                  = "EXTERNAL"
  is_secure                 = false
  null_input_behavior       = "CALLED_ON_NULL_INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/euno_instructions"
  headers                   = local.api_headers
  comment                   = "Get detailed instructions on using Euno MCP server"
}

resource "snowflake_function" "euno_count_resources" {
  name     = "euno_count_resources"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "query"
    type = "VARIANT"
  }

  arguments {
    name = "reasoning"
    type = "VARIANT"
  }

  arguments {
    name = "group_by_property"
    type = "VARIANT"
  }

  arguments {
    name = "resource_relationship_schema"
    type = "VARIANT"
  }

  arguments {
    name = "related_use_cases"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  language                  = "EXTERNAL"
  is_secure                 = false
  null_input_behavior       = "CALLED_ON_NULL_INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/count_resources"
  headers                   = local.api_headers
  comment                   = "Count resources matching a query with optional grouping"
}

resource "snowflake_function" "euno_fetch_single_resource" {
  name     = "euno_fetch_single_resource"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "resource_uri"
    type = "VARIANT"
  }

  arguments {
    name = "properties_to_fetch"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  language                  = "EXTERNAL"
  is_secure                 = false
  null_input_behavior       = "CALLED_ON_NULL_INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/fetch_single_resource"
  headers                   = local.api_headers
  comment                   = "Retrieve a single resource by URI"
}

resource "snowflake_function" "euno_find_resource_by_name" {
  name     = "euno_find_resource_by_name"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "resource_name"
    type = "VARIANT"
  }

  arguments {
    name = "reasoning"
    type = "VARIANT"
  }

  arguments {
    name = "filter_by_resource_types"
    type = "VARIANT"
  }

  arguments {
    name = "properties_to_return"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  language                  = "EXTERNAL"
  is_secure                 = false
  null_input_behavior       = "CALLED_ON_NULL_INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/find_resource_by_name"
  headers                   = local.api_headers
  comment                   = "Find resources by name using similarity matching"
}

resource "snowflake_function" "euno_find_resources_for_topic" {
  name     = "euno_find_resources_for_topic"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "query_strings"
    type = "VARIANT"
  }

  arguments {
    name = "reasoning"
    type = "VARIANT"
  }

  arguments {
    name = "filter_by_resource_types"
    type = "VARIANT"
  }

  arguments {
    name = "properties_to_return"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  language                  = "EXTERNAL"
  is_secure                 = false
  null_input_behavior       = "CALLED_ON_NULL_INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/find_resources_for_topic"
  headers                   = local.api_headers
  comment                   = "Find resources related to a topic using semantic search"
}

resource "snowflake_function" "euno_get_upstream_lineage" {
  name     = "euno_get_upstream_lineage"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "resource_uri"
    type = "VARIANT"
  }

  arguments {
    name = "reasoning"
    type = "VARIANT"
  }

  arguments {
    name = "properties_to_fetch"
    type = "VARIANT"
  }

  arguments {
    name = "related_use_cases"
    type = "VARIANT"
  }

  arguments {
    name = "filter_by_resource_types"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  language                  = "EXTERNAL"
  is_secure                 = false
  null_input_behavior       = "CALLED_ON_NULL_INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/get_upstream_lineage"
  headers                   = local.api_headers
  comment                   = "Get upstream lineage/dependencies for a resource"
}

resource "snowflake_function" "euno_resource_impact_analysis" {
  name     = "euno_resource_impact_analysis"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "uri"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  language                  = "EXTERNAL"
  is_secure                 = false
  null_input_behavior       = "CALLED_ON_NULL_INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/resource_impact_analysis"
  headers                   = local.api_headers
  comment                   = "Analyze downstream impact of changes to a resource"
}

resource "snowflake_function" "euno_search_resources" {
  name     = "euno_search_resources"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "query"
    type = "VARIANT"
  }

  arguments {
    name = "reasoning"
    type = "VARIANT"
  }

  arguments {
    name = "resource_relationship_schema"
    type = "VARIANT"
  }

  arguments {
    name = "related_use_cases"
    type = "VARIANT"
  }

  arguments {
    name = "order_by_property"
    type = "VARIANT"
  }

  arguments {
    name = "order_direction"
    type = "VARIANT"
  }

  arguments {
    name = "properties_to_return"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  language                  = "EXTERNAL"
  is_secure                 = false
  null_input_behavior       = "CALLED_ON_NULL_INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/search_resources"
  headers                   = local.api_headers
  comment                   = "Advanced search with EQL or natural language queries"
}

resource "snowflake_function" "euno_documentation_search" {
  name     = "euno_documentation_search"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "query"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  language                  = "EXTERNAL"
  is_secure                 = false
  null_input_behavior       = "CALLED_ON_NULL_INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/documentation_search"
  headers                   = local.api_headers
  comment                   = "Search Euno documentation"
}

resource "snowflake_function" "euno_documentation_get_full_document" {
  name     = "euno_documentation_get_full_document"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "url"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  language                  = "EXTERNAL"
  is_secure                 = false
  null_input_behavior       = "CALLED_ON_NULL_INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/documentation_get_full_document"
  headers                   = local.api_headers
  comment                   = "Retrieve full documentation by URL"
}

resource "snowflake_function" "euno_documentation_get_surrounding_context" {
  name     = "euno_documentation_get_surrounding_context"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "chunk_id"
    type = "VARIANT"
  }

  arguments {
    name = "window_size"
    type = "VARIANT"
  }

  return_type               = "VARIANT"
  language                  = "EXTERNAL"
  is_secure                 = false
  null_input_behavior       = "CALLED_ON_NULL_INPUT"
  return_behavior           = "VOLATILE"
  api_integration           = snowflake_api_integration.euno_mcp.name
  url_of_proxy_and_resource = "${local.api_base_url}/documentation_get_surrounding_context"
  headers                   = local.api_headers
  comment                   = "Get context around a documentation chunk"
}

# Wrapper functions, permissions, and agent SQL generation are defined in separate files:
# - wrapper_functions.tf: SQL wrapper functions for type safety
# - permissions.tf: Role creation and permission grants
# - agent.tf: Agent SQL generation (requires manual application due to provider limitations)
