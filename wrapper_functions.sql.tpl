-- This file should be applied after running `terraform apply`
-- Replace ${DATABASE_NAME} and ${SCHEMA_NAME} with your actual values

USE DATABASE ${DATABASE_NAME};
USE SCHEMA ${SCHEMA_NAME};

-- 1. EUNO_INSTRUCTIONS: Get detailed instructions on using Euno MCP server
CREATE OR REPLACE FUNCTION euno_instructions_wrapper(page NUMBER)
  RETURNS STRING
AS
$$
  SELECT euno_instructions(TO_VARIANT(page))::STRING
$$;

-- 2. COUNT_RESOURCES: Count resources matching a query with optional grouping
CREATE OR REPLACE FUNCTION euno_count_resources_wrapper(
  query STRING,
  reasoning STRING,
  group_by_property STRING,
  resource_relationship_schema STRING,
  related_use_cases STRING
)
  RETURNS STRING
AS
$$
  SELECT euno_count_resources(
    TO_VARIANT(query),
    TO_VARIANT(reasoning),
    TO_VARIANT(group_by_property),
    TO_VARIANT(resource_relationship_schema),
    TO_VARIANT(CASE WHEN related_use_cases = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(related_use_cases, ',') END)
  )::STRING
$$;

-- 3. FETCH_SINGLE_RESOURCE: Retrieve a single resource by URI
CREATE OR REPLACE FUNCTION euno_fetch_single_resource_wrapper(
  resource_uri STRING,
  properties_to_fetch STRING
)
  RETURNS STRING
AS
$$
  SELECT euno_fetch_single_resource(
    TO_VARIANT(resource_uri),
    TO_VARIANT(CASE WHEN properties_to_fetch = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(properties_to_fetch, ',') END)
  )::STRING
$$;

-- 4. FIND_RESOURCE_BY_NAME: Find resources by name using similarity matching
CREATE OR REPLACE FUNCTION euno_find_resource_by_name_wrapper(
  resource_name STRING,
  reasoning STRING,
  filter_by_resource_types STRING,
  properties_to_return STRING
)
  RETURNS STRING
AS
$$
  SELECT euno_find_resource_by_name(
    TO_VARIANT(resource_name),
    TO_VARIANT(reasoning),
    TO_VARIANT(CASE WHEN filter_by_resource_types = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(filter_by_resource_types, ',') END),
    TO_VARIANT(CASE WHEN properties_to_return = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(properties_to_return, ',') END)
  )::STRING
$$;

-- 5. FIND_RESOURCES_FOR_TOPIC: Find resources related to a topic using semantic search
CREATE OR REPLACE FUNCTION euno_find_resources_for_topic_wrapper(
  query_strings STRING,
  reasoning STRING,
  filter_by_resource_types STRING,
  properties_to_return STRING
)
  RETURNS STRING
AS
$$
  SELECT euno_find_resources_for_topic(
    TO_VARIANT(CASE WHEN query_strings = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(query_strings, ',') END),
    TO_VARIANT(reasoning),
    TO_VARIANT(CASE WHEN filter_by_resource_types = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(filter_by_resource_types, ',') END),
    TO_VARIANT(CASE WHEN properties_to_return = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(properties_to_return, ',') END)
  )::STRING
$$;

-- 6. GET_UPSTREAM_LINEAGE: Get upstream lineage/dependencies for a resource
CREATE OR REPLACE FUNCTION euno_get_upstream_lineage_wrapper(
  resource_uri STRING,
  reasoning STRING,
  properties_to_fetch STRING,
  related_use_cases STRING,
  filter_by_resource_types STRING
)
  RETURNS STRING
AS
$$
  SELECT euno_get_upstream_lineage(
    TO_VARIANT(resource_uri),
    TO_VARIANT(reasoning),
    TO_VARIANT(CASE WHEN properties_to_fetch = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(properties_to_fetch, ',') END),
    TO_VARIANT(CASE WHEN related_use_cases = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(related_use_cases, ',') END),
    TO_VARIANT(CASE WHEN filter_by_resource_types = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(filter_by_resource_types, ',') END)
  )::STRING
$$;

-- 7. RESOURCE_IMPACT_ANALYSIS: Analyze downstream impact of changes to a resource
CREATE OR REPLACE FUNCTION euno_resource_impact_analysis_wrapper(uri STRING)
  RETURNS STRING
AS
$$
  SELECT euno_resource_impact_analysis(TO_VARIANT(uri))::STRING
$$;

-- 8. SEARCH_RESOURCES: Advanced search with EQL or natural language queries
CREATE OR REPLACE FUNCTION euno_search_resources_wrapper(
  query STRING,
  reasoning STRING,
  resource_relationship_schema STRING,
  related_use_cases STRING,
  order_by_property STRING,
  order_direction STRING,
  properties_to_return STRING
)
  RETURNS STRING
AS
$$
  SELECT euno_search_resources(
    TO_VARIANT(query),
    TO_VARIANT(reasoning),
    TO_VARIANT(resource_relationship_schema),
    TO_VARIANT(CASE WHEN related_use_cases = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(related_use_cases, ',') END),
    TO_VARIANT(order_by_property),
    TO_VARIANT(order_direction),
    TO_VARIANT(CASE WHEN properties_to_return = '' THEN ARRAY_CONSTRUCT() ELSE SPLIT(properties_to_return, ',') END)
  )::STRING
$$;

-- 9. DOCUMENTATION_SEARCH: Search Euno documentation
CREATE OR REPLACE FUNCTION euno_documentation_search_wrapper(query STRING)
  RETURNS STRING
AS
$$
  SELECT euno_documentation_search(TO_VARIANT(query))::STRING
$$;

-- 10. DOCUMENTATION_GET_FULL_DOCUMENT: Retrieve full documentation by URL
CREATE OR REPLACE FUNCTION euno_documentation_get_full_document_wrapper(url STRING)
  RETURNS STRING
AS
$$
  SELECT euno_documentation_get_full_document(TO_VARIANT(url))::STRING
$$;

-- 11. DOCUMENTATION_GET_SURROUNDING_CONTEXT: Get context around a documentation chunk
CREATE OR REPLACE FUNCTION euno_documentation_get_surrounding_context_wrapper(
  chunk_id STRING,
  window_size NUMBER
)
  RETURNS STRING
AS
$$
  SELECT euno_documentation_get_surrounding_context(
    TO_VARIANT(chunk_id),
    TO_VARIANT(window_size)
  )::STRING
$$;
