# Wrapper Functions - Type-safe SQL wrappers for external functions
# These provide a clean interface with proper SQL types and handle data conversions

# 1. EUNO_INSTRUCTIONS: Get detailed instructions on using Euno MCP server
resource "snowflake_function" "euno_instructions_wrapper" {
  name     = "euno_instructions_wrapper"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "page"
    type = "NUMBER"
  }

  return_type = "STRING"
  language    = "SQL"
  statement   = "SELECT \"${snowflake_database.intelligence.name}\".\"${snowflake_schema.agents.name}\".\"euno_instructions\"(TO_VARIANT(page))::STRING"
  comment     = "Wrapper function for euno_instructions with type safety"

  depends_on = [snowflake_external_function.euno_instructions]
}

# 2. COUNT_RESOURCES: Count resources matching a query with optional grouping
resource "snowflake_function" "euno_count_resources_wrapper" {
  name     = "euno_count_resources_wrapper"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "query"
    type = "STRING"
  }

  arguments {
    name = "reasoning"
    type = "STRING"
  }

  arguments {
    name = "group_by_property"
    type = "STRING"
  }

  arguments {
    name = "resource_relationship_schema"
    type = "STRING"
  }

  arguments {
    name = "related_use_cases"
    type = "STRING"
  }

  return_type = "STRING"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."euno_count_resources"(
      TO_VARIANT(query),
      TO_VARIANT(reasoning),
      TO_VARIANT(group_by_property),
      TO_VARIANT(resource_relationship_schema),
      TO_VARIANT(CASE WHEN related_use_cases = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(related_use_cases, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_count_resources with type safety"

  depends_on = [snowflake_external_function.euno_count_resources]
}

# 3. FETCH_SINGLE_RESOURCE: Retrieve a single resource by URI
resource "snowflake_function" "euno_fetch_single_resource_wrapper" {
  name     = "euno_fetch_single_resource_wrapper"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "resource_uri"
    type = "STRING"
  }

  arguments {
    name = "properties_to_fetch"
    type = "STRING"
  }

  return_type = "STRING"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."euno_fetch_single_resource"(
      TO_VARIANT(resource_uri),
      TO_VARIANT(CASE WHEN properties_to_fetch = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(properties_to_fetch, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_fetch_single_resource with type safety"

  depends_on = [snowflake_external_function.euno_fetch_single_resource]
}

# 4. FIND_RESOURCE_BY_NAME: Find resources by name using similarity matching
resource "snowflake_function" "euno_find_resource_by_name_wrapper" {
  name     = "euno_find_resource_by_name_wrapper"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "resource_name"
    type = "STRING"
  }

  arguments {
    name = "reasoning"
    type = "STRING"
  }

  arguments {
    name = "filter_by_resource_types"
    type = "STRING"
  }

  arguments {
    name = "properties_to_return"
    type = "STRING"
  }

  return_type = "STRING"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."euno_find_resource_by_name"(
      TO_VARIANT(resource_name),
      TO_VARIANT(reasoning),
      TO_VARIANT(CASE WHEN filter_by_resource_types = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(filter_by_resource_types, ',') END),
      TO_VARIANT(CASE WHEN properties_to_return = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(properties_to_return, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_find_resource_by_name with type safety"

  depends_on = [snowflake_external_function.euno_find_resource_by_name]
}

# 5. FIND_RESOURCES_FOR_TOPIC: Find resources related to a topic using semantic search
resource "snowflake_function" "euno_find_resources_for_topic_wrapper" {
  name     = "euno_find_resources_for_topic_wrapper"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "query_strings"
    type = "STRING"
  }

  arguments {
    name = "reasoning"
    type = "STRING"
  }

  arguments {
    name = "filter_by_resource_types"
    type = "STRING"
  }

  arguments {
    name = "properties_to_return"
    type = "STRING"
  }

  return_type = "STRING"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."euno_find_resources_for_topic"(
      TO_VARIANT(CASE WHEN query_strings = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(query_strings, ',') END),
      TO_VARIANT(reasoning),
      TO_VARIANT(CASE WHEN filter_by_resource_types = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(filter_by_resource_types, ',') END),
      TO_VARIANT(CASE WHEN properties_to_return = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(properties_to_return, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_find_resources_for_topic with type safety"

  depends_on = [snowflake_external_function.euno_find_resources_for_topic]
}

# 6. GET_UPSTREAM_LINEAGE: Get upstream lineage/dependencies for a resource
resource "snowflake_function" "euno_get_upstream_lineage_wrapper" {
  name     = "euno_get_upstream_lineage_wrapper"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "resource_uri"
    type = "STRING"
  }

  arguments {
    name = "reasoning"
    type = "STRING"
  }

  arguments {
    name = "properties_to_fetch"
    type = "STRING"
  }

  arguments {
    name = "related_use_cases"
    type = "STRING"
  }

  arguments {
    name = "filter_by_resource_types"
    type = "STRING"
  }

  return_type = "STRING"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."euno_get_upstream_lineage"(
      TO_VARIANT(resource_uri),
      TO_VARIANT(reasoning),
      TO_VARIANT(CASE WHEN properties_to_fetch = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(properties_to_fetch, ',') END),
      TO_VARIANT(CASE WHEN related_use_cases = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(related_use_cases, ',') END),
      TO_VARIANT(CASE WHEN filter_by_resource_types = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(filter_by_resource_types, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_get_upstream_lineage with type safety"

  depends_on = [snowflake_external_function.euno_get_upstream_lineage]
}

# 7. RESOURCE_IMPACT_ANALYSIS: Analyze downstream impact of changes to a resource
resource "snowflake_function" "euno_resource_impact_analysis_wrapper" {
  name     = "euno_resource_impact_analysis_wrapper"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "uri"
    type = "STRING"
  }

  return_type = "STRING"
  language    = "SQL"
  statement   = "SELECT \"${snowflake_database.intelligence.name}\".\"${snowflake_schema.agents.name}\".\"euno_resource_impact_analysis\"(TO_VARIANT(uri))::STRING"
  comment     = "Wrapper function for euno_resource_impact_analysis with type safety"

  depends_on = [snowflake_external_function.euno_resource_impact_analysis]
}

# 8. SEARCH_RESOURCES: Advanced search with EQL or natural language queries
resource "snowflake_function" "euno_search_resources_wrapper" {
  name     = "euno_search_resources_wrapper"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "query"
    type = "STRING"
  }

  arguments {
    name = "reasoning"
    type = "STRING"
  }

  arguments {
    name = "resource_relationship_schema"
    type = "STRING"
  }

  arguments {
    name = "related_use_cases"
    type = "STRING"
  }

  arguments {
    name = "order_by_property"
    type = "STRING"
  }

  arguments {
    name = "order_direction"
    type = "STRING"
  }

  arguments {
    name = "properties_to_return"
    type = "STRING"
  }

  return_type = "STRING"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."euno_search_resources"(
      TO_VARIANT(query),
      TO_VARIANT(reasoning),
      TO_VARIANT(resource_relationship_schema),
      TO_VARIANT(CASE WHEN related_use_cases = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(related_use_cases, ',') END),
      TO_VARIANT(order_by_property),
      TO_VARIANT(order_direction),
      TO_VARIANT(CASE WHEN properties_to_return = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(properties_to_return, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_search_resources with type safety"

  depends_on = [snowflake_external_function.euno_search_resources]
}

# 9. DOCUMENTATION_SEARCH: Search Euno documentation
resource "snowflake_function" "euno_documentation_search_wrapper" {
  name     = "euno_documentation_search_wrapper"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "query"
    type = "STRING"
  }

  return_type = "STRING"
  language    = "SQL"
  statement   = "SELECT \"${snowflake_database.intelligence.name}\".\"${snowflake_schema.agents.name}\".\"euno_documentation_search\"(TO_VARIANT(query))::STRING"
  comment     = "Wrapper function for euno_documentation_search with type safety"

  depends_on = [snowflake_external_function.euno_documentation_search]
}

# 10. DOCUMENTATION_GET_FULL_DOCUMENT: Retrieve full documentation by URL
resource "snowflake_function" "euno_documentation_get_full_document_wrapper" {
  name     = "euno_documentation_get_full_document_wrapper"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "url"
    type = "STRING"
  }

  return_type = "STRING"
  language    = "SQL"
  statement   = "SELECT \"${snowflake_database.intelligence.name}\".\"${snowflake_schema.agents.name}\".\"euno_documentation_get_full_document\"(TO_VARIANT(url))::STRING"
  comment     = "Wrapper function for euno_documentation_get_full_document with type safety"

  depends_on = [snowflake_external_function.euno_documentation_get_full_document]
}

# 11. DOCUMENTATION_GET_SURROUNDING_CONTEXT: Get context around a documentation chunk
resource "snowflake_function" "euno_documentation_get_surrounding_context_wrapper" {
  name     = "euno_documentation_get_surrounding_context_wrapper"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "chunk_id"
    type = "STRING"
  }

  arguments {
    name = "window_size"
    type = "NUMBER"
  }

  return_type = "STRING"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."euno_documentation_get_surrounding_context"(
      TO_VARIANT(chunk_id),
      TO_VARIANT(window_size)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_documentation_get_surrounding_context with type safety"

  depends_on = [snowflake_external_function.euno_documentation_get_surrounding_context]
}
