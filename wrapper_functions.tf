# Wrapper Functions - Type-safe SQL wrappers for external functions
# These provide a clean interface with proper SQL types and handle data conversions

# 1. EUNO_INSTRUCTIONS: Get detailed instructions on using Euno MCP server
resource "snowflake_function" "euno_instructions_wrapper" {
  name     = "EUNO_INSTRUCTIONS_WRAPPER"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "PAGE"
    type = "NUMBER"
  }

  return_type = "VARCHAR"
  language    = "SQL"
  statement   = "SELECT \"${snowflake_database.intelligence.name}\".\"${snowflake_schema.agents.name}\".\"EUNO_INSTRUCTIONS\"(TO_VARIANT(PAGE))::STRING"
  comment     = "Wrapper function for euno_instructions with type safety"

  depends_on = [snowflake_external_function.euno_instructions]
}

# 2. COUNT_RESOURCES: Count resources matching a query with optional grouping
resource "snowflake_function" "euno_count_resources_wrapper" {
  name     = "EUNO_COUNT_RESOURCES_WRAPPER"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "QUERY"
    type = "VARCHAR"
  }

  arguments {
    name = "REASONING"
    type = "VARCHAR"
  }

  arguments {
    name = "GROUP_BY_PROPERTY"
    type = "VARCHAR"
  }

  arguments {
    name = "RESOURCE_RELATIONSHIP_SCHEMA"
    type = "VARCHAR"
  }

  arguments {
    name = "RELATED_USE_CASES"
    type = "VARCHAR"
  }

  return_type = "VARCHAR"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."EUNO_COUNT_RESOURCES"(
      TO_VARIANT(QUERY),
      TO_VARIANT(REASONING),
      TO_VARIANT(GROUP_BY_PROPERTY),
      TO_VARIANT(RESOURCE_RELATIONSHIP_SCHEMA),
      TO_VARIANT(CASE WHEN RELATED_USE_CASES = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(RELATED_USE_CASES, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_count_resources with type safety"

  depends_on = [snowflake_external_function.euno_count_resources]
}

# 3. FETCH_SINGLE_RESOURCE: Retrieve a single resource by URI
resource "snowflake_function" "euno_fetch_single_resource_wrapper" {
  name     = "EUNO_FETCH_SINGLE_RESOURCE_WRAPPER"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "RESOURCE_URI"
    type = "VARCHAR"
  }

  arguments {
    name = "PROPERTIES_TO_FETCH"
    type = "VARCHAR"
  }

  return_type = "VARCHAR"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."EUNO_FETCH_SINGLE_RESOURCE"(
      TO_VARIANT(RESOURCE_URI),
      TO_VARIANT(CASE WHEN PROPERTIES_TO_FETCH = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(PROPERTIES_TO_FETCH, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_fetch_single_resource with type safety"

  depends_on = [snowflake_external_function.euno_fetch_single_resource]
}

# 4. FIND_RESOURCE_BY_NAME: Find resources by name using similarity matching
resource "snowflake_function" "euno_find_resource_by_name_wrapper" {
  name     = "EUNO_FIND_RESOURCE_BY_NAME_WRAPPER"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "RESOURCE_NAME"
    type = "VARCHAR"
  }

  arguments {
    name = "REASONING"
    type = "VARCHAR"
  }

  arguments {
    name = "FILTER_BY_RESOURCE_TYPES"
    type = "VARCHAR"
  }

  arguments {
    name = "PROPERTIES_TO_RETURN"
    type = "VARCHAR"
  }

  return_type = "VARCHAR"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."EUNO_FIND_RESOURCE_BY_NAME"(
      TO_VARIANT(RESOURCE_NAME),
      TO_VARIANT(REASONING),
      TO_VARIANT(CASE WHEN FILTER_BY_RESOURCE_TYPES = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(FILTER_BY_RESOURCE_TYPES, ',') END),
      TO_VARIANT(CASE WHEN PROPERTIES_TO_RETURN = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(PROPERTIES_TO_RETURN, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_find_resource_by_name with type safety"

  depends_on = [snowflake_external_function.euno_find_resource_by_name]
}

# 5. FIND_RESOURCES_FOR_TOPIC: Find resources related to a topic using semantic search
resource "snowflake_function" "euno_find_resources_for_topic_wrapper" {
  name     = "EUNO_FIND_RESOURCES_FOR_TOPIC_WRAPPER"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "QUERY_STRINGS"
    type = "VARCHAR"
  }

  arguments {
    name = "REASONING"
    type = "VARCHAR"
  }

  arguments {
    name = "FILTER_BY_RESOURCE_TYPES"
    type = "VARCHAR"
  }

  arguments {
    name = "PROPERTIES_TO_RETURN"
    type = "VARCHAR"
  }

  return_type = "VARCHAR"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."EUNO_FIND_RESOURCES_FOR_TOPIC"(
      TO_VARIANT(CASE WHEN QUERY_STRINGS = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(QUERY_STRINGS, ',') END),
      TO_VARIANT(REASONING),
      TO_VARIANT(CASE WHEN FILTER_BY_RESOURCE_TYPES = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(FILTER_BY_RESOURCE_TYPES, ',') END),
      TO_VARIANT(CASE WHEN PROPERTIES_TO_RETURN = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(PROPERTIES_TO_RETURN, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_find_resources_for_topic with type safety"

  depends_on = [snowflake_external_function.euno_find_resources_for_topic]
}

# 6. GET_UPSTREAM_LINEAGE: Get upstream lineage/dependencies for a resource
resource "snowflake_function" "euno_get_upstream_lineage_wrapper" {
  name     = "EUNO_GET_UPSTREAM_LINEAGE_WRAPPER"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "RESOURCE_URI"
    type = "VARCHAR"
  }

  arguments {
    name = "REASONING"
    type = "VARCHAR"
  }

  arguments {
    name = "PROPERTIES_TO_FETCH"
    type = "VARCHAR"
  }

  arguments {
    name = "RELATED_USE_CASES"
    type = "VARCHAR"
  }

  arguments {
    name = "FILTER_BY_RESOURCE_TYPES"
    type = "VARCHAR"
  }

  return_type = "VARCHAR"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."EUNO_GET_UPSTREAM_LINEAGE"(
      TO_VARIANT(RESOURCE_URI),
      TO_VARIANT(REASONING),
      TO_VARIANT(CASE WHEN PROPERTIES_TO_FETCH = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(PROPERTIES_TO_FETCH, ',') END),
      TO_VARIANT(CASE WHEN RELATED_USE_CASES = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(RELATED_USE_CASES, ',') END),
      TO_VARIANT(CASE WHEN FILTER_BY_RESOURCE_TYPES = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(FILTER_BY_RESOURCE_TYPES, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_get_upstream_lineage with type safety"

  depends_on = [snowflake_external_function.euno_get_upstream_lineage]
}

# 7. RESOURCE_IMPACT_ANALYSIS: Analyze downstream impact of changes to a resource
resource "snowflake_function" "euno_resource_impact_analysis_wrapper" {
  name     = "EUNO_RESOURCE_IMPACT_ANALYSIS_WRAPPER"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "URI"
    type = "VARCHAR"
  }

  return_type = "VARCHAR"
  language    = "SQL"
  statement   = "SELECT \"${snowflake_database.intelligence.name}\".\"${snowflake_schema.agents.name}\".\"EUNO_RESOURCE_IMPACT_ANALYSIS\"(TO_VARIANT(URI))::STRING"
  comment     = "Wrapper function for euno_resource_impact_analysis with type safety"

  depends_on = [snowflake_external_function.euno_resource_impact_analysis]
}

# 8. SEARCH_RESOURCES: Advanced search with EQL or natural language queries
resource "snowflake_function" "euno_search_resources_wrapper" {
  name     = "EUNO_SEARCH_RESOURCES_WRAPPER"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "QUERY"
    type = "VARCHAR"
  }

  arguments {
    name = "REASONING"
    type = "VARCHAR"
  }

  arguments {
    name = "RESOURCE_RELATIONSHIP_SCHEMA"
    type = "VARCHAR"
  }

  arguments {
    name = "RELATED_USE_CASES"
    type = "VARCHAR"
  }

  arguments {
    name = "ORDER_BY_PROPERTY"
    type = "VARCHAR"
  }

  arguments {
    name = "ORDER_DIRECTION"
    type = "VARCHAR"
  }

  arguments {
    name = "PROPERTIES_TO_RETURN"
    type = "VARCHAR"
  }

  return_type = "VARCHAR"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."EUNO_SEARCH_RESOURCES"(
      TO_VARIANT(QUERY),
      TO_VARIANT(REASONING),
      TO_VARIANT(RESOURCE_RELATIONSHIP_SCHEMA),
      TO_VARIANT(CASE WHEN RELATED_USE_CASES = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(RELATED_USE_CASES, ',') END),
      TO_VARIANT(ORDER_BY_PROPERTY),
      TO_VARIANT(ORDER_DIRECTION),
      TO_VARIANT(CASE WHEN PROPERTIES_TO_RETURN = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(PROPERTIES_TO_RETURN, ',') END)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_search_resources with type safety"

  depends_on = [snowflake_external_function.euno_search_resources]
}

# 9. DOCUMENTATION_SEARCH: Search Euno documentation
resource "snowflake_function" "euno_documentation_search_wrapper" {
  name     = "EUNO_DOCUMENTATION_SEARCH_WRAPPER"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "QUERY"
    type = "VARCHAR"
  }

  return_type = "VARCHAR"
  language    = "SQL"
  statement   = "SELECT \"${snowflake_database.intelligence.name}\".\"${snowflake_schema.agents.name}\".\"EUNO_DOCUMENTATION_SEARCH\"(TO_VARIANT(QUERY))::STRING"
  comment     = "Wrapper function for euno_documentation_search with type safety"

  depends_on = [snowflake_external_function.euno_documentation_search]
}

# 10. DOCUMENTATION_GET_FULL_DOCUMENT: Retrieve full documentation by URL
resource "snowflake_function" "euno_documentation_get_full_document_wrapper" {
  name     = "EUNO_DOCUMENTATION_GET_FULL_DOCUMENT_WRAPPER"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "URL"
    type = "VARCHAR"
  }

  return_type = "VARCHAR"
  language    = "SQL"
  statement   = "SELECT \"${snowflake_database.intelligence.name}\".\"${snowflake_schema.agents.name}\".\"EUNO_DOCUMENTATION_GET_FULL_DOCUMENT\"(TO_VARIANT(URL))::STRING"
  comment     = "Wrapper function for euno_documentation_get_full_document with type safety"

  depends_on = [snowflake_external_function.euno_documentation_get_full_document]
}

# 11. DOCUMENTATION_GET_SURROUNDING_CONTEXT: Get context around a documentation chunk
resource "snowflake_function" "euno_documentation_get_surrounding_context_wrapper" {
  name     = "EUNO_DOCUMENTATION_GET_SURROUNDING_CONTEXT_WRAPPER"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  arguments {
    name = "CHUNK_ID"
    type = "VARCHAR"
  }

  arguments {
    name = "WINDOW_SIZE"
    type = "NUMBER"
  }

  return_type = "VARCHAR"
  language    = "SQL"
  statement   = <<-SQL
    SELECT "${snowflake_database.intelligence.name}"."${snowflake_schema.agents.name}"."EUNO_DOCUMENTATION_GET_SURROUNDING_CONTEXT"(
      TO_VARIANT(CHUNK_ID),
      TO_VARIANT(WINDOW_SIZE)
    )::STRING
  SQL
  comment     = "Wrapper function for euno_documentation_get_surrounding_context with type safety"

  depends_on = [snowflake_external_function.euno_documentation_get_surrounding_context]
}
