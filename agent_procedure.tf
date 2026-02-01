# Agent Creation via Stored Procedure
# This creates a JavaScript procedure that users call to create the agent
# This is cleaner than running a SQL file!

resource "snowflake_procedure_javascript" "create_euno_agent" {
  name     = "CREATE_EUNO_AGENT"
  database = snowflake_database.intelligence.name
  schema   = snowflake_schema.agents.name

  return_type = "STRING"

  # JavaScript allows us to use backticks, avoiding $$ conflicts!
  procedure_definition = <<-JS
    var agentSQL = `CREATE OR REPLACE AGENT ${var.agent_name}
  COMMENT = 'Euno.ai Data Pipeline Assistant Agent - using external functions with type-safe wrapper layer'
  PROFILE = '{
    "display_name": "${var.agent_display_name}",
    "avatar": "${var.agent_avatar}",
    "color": "${var.agent_color}"
  }'
  FROM SPECIFICATION
  \$\$
models:
  orchestration: ${var.orchestration_model}

orchestration:
  budget:
    seconds: ${var.agent_budget_seconds}
    tokens: ${var.agent_budget_tokens}

instructions:
  system: "You are a data agent that helps users understand and manage their data pipeline using the Euno AI platform."
  orchestration: >
    You have access to a comprehensive set of primitive tools from the Euno Assistant AI.
    These tools give you granular control over searching, analyzing, and understanding the data pipeline.


    IMPORTANT:
    ALWAYS start by calling the tool 'euno_instructions' to get updated guidelines on how to work with Euno, which resource kinds and properties exists, how to perform certain tasks etc. It is VERY IMPORTANT you do not skip this step and never use any of the tools below before calling euno_instructions.
    START FROM PAGE 1 and read through ALL THE PAGES of the instructions returned by euno_instructions before proceeding to use any other tool.
    Then use Euno tools, being strategic about which tool to use:
    - Use 'generate_eql_query' to convert natural language to EQL queries
    - Use 'execute_eql_query' to run EQL queries and get resource results
    - Use 'execute_eql_count' for aggregations or counts of resources
    - Use 'find_resource_by_name' for finding resources by their name
    - Use 'find_resources_for_topic' for semantic searches across resource descriptions
    - Use 'get_upstream_lineage' to trace dependencies and data flow
    - Use 'resource_impact_analysis' to understand downstream effects of changes
    - Use 'fetch_single_resource' when you already have a URI and need specific properties
    - Use documentation tools to learn about Euno features and capabilities

    REMEMBER TO ALWAYS start by calling 'euno_instructions' FULLY to understand the full capabilities and guidelines.

    In Euno, all data pipeline entities (tables, dashboards, columns, etc.) are called 'resources'.
    Each resource has a unique URI that identifies it across the platform.

    VERY IMPORTANT: Euno provides metadata about the data pipeline - lineage, usage, logic, documentation, etc.
    Euno does NOT have access to actual data values. If users ask for actual data, use Euno to find the SQL
    logic or table definitions, then guide them to query the data warehouse directly.

  response: >
    Be concise and accurate in your responses.
    ALWAYS provide full links to resources you mention - these links are formatted using the resource's name and uri properties.
    Format: [{resource.name}](https://api.app.euno.ai/link-to-resource?uri={resource.uri}).
    When providing code snippets (SQL, Python, etc.), use proper code blocks with syntax highlighting.
    Present information clearly with proper formatting and structure.

tools:
  - tool_spec:
      type: "generic"
      name: "euno_instructions"
      description: "Get comprehensive instructions on using the Euno MCP server and understanding the data pipeline metadata capabilities, existing properties and relationships, resource types, and best practices."
      input_schema:
        type: "object"
        properties:
          page:
            type: "number"
            description: "Page number of the instructions to retrieve (starting from 1)"
        required: []

  - tool_spec:
      type: "generic"
      name: "euno_generate_eql_query"
      description: "Generate an EQL (Euno Query Language) query from a natural language description. Use this first to convert user requests into EQL, then use execute_eql_query or execute_eql_count to run the query."
      input_schema:
        type: "object"
        properties:
          query:
            type: "string"
            description: "Natural language description of what resources to find (e.g. 'tables in analytics schema', 'dashboards with no usage'). Use precise, specific descriptions."
        required: ["query"]

  - tool_spec:
      type: "generic"
      name: "euno_execute_eql_query"
      description: "Search for data pipeline resources using an EQL query. Use generate_eql_query first to convert natural language to EQL, then use this tool to execute the query and get results."
      input_schema:
        type: "object"
        properties:
          eql_query:
            type: "string"
            description: "A valid EQL query string. Use generate_eql_query to create this from natural language."
          reasoning:
            type: "string"
            description: "Explain why you're searching and what resource types/properties you expect to find"
          resource_relationship_schema:
            type: "string"
            description: "For multi-resource queries, describe the relationship chain (e.g. 'dashboard -> view -> table'). Leave empty if not applicable."
          related_use_cases:
            type: "string"
            description: "Comma-separated list of use case identifiers you're following (e.g. 'TRACE_LINEAGE,FIND_OWNERS'). Leave empty if not applicable."
          order_by_property:
            type: "string"
            description: "Property name to sort results by. Leave empty for default sorting."
          order_direction:
            type: "string"
            description: "'ascending' or 'descending'. Leave empty for default order."
          properties_to_return:
            type: "string"
            description: "Comma-separated list of property names to include in results (e.g. 'name,owner,description'). uri is always included. Leave empty for defaults."
          page:
            type: "number"
            description: "Page number for pagination (starting from 1). Default is 1."
          page_size:
            type: "number"
            description: "Number of results per page. Default is 20."
        required: ["eql_query", "reasoning", "resource_relationship_schema", "related_use_cases", "order_by_property", "order_direction", "properties_to_return", "page", "page_size"]

  - tool_spec:
      type: "generic"
      name: "euno_execute_eql_count"
      description: "Count resources matching an EQL query, optionally grouped by a property. Use generate_eql_query first to convert natural language to EQL, then use this tool to count results."
      input_schema:
        type: "object"
        properties:
          eql_query:
            type: "string"
            description: "A valid EQL query string. Use generate_eql_query to create this from natural language."
          reasoning:
            type: "string"
            description: "Explain what you're counting and why"
          group_by_property:
            type: "string"
            description: "Property to group counts by (e.g. 'type', 'owner'). Leave empty for total count only."
          resource_relationship_schema:
            type: "string"
            description: "For multi-resource queries, describe the relationship chain. Leave empty if not applicable."
          related_use_cases:
            type: "string"
            description: "Comma-separated list of related use case identifiers (e.g. 'TRACE_LINEAGE,IMPACT_ANALYSIS'). Leave empty if not applicable."
        required: ["eql_query", "reasoning", "group_by_property", "resource_relationship_schema", "related_use_cases"]

  - tool_spec:
      type: "generic"
      name: "euno_fetch_single_resource"
      description: "Retrieve detailed information about a specific resource by its URI. Use when you already know the exact URI and need specific properties."
      input_schema:
        type: "object"
        properties:
          resource_uri:
            type: "string"
            description: "The exact URI of the resource to fetch"
          properties_to_fetch:
            type: "string"
            description: "Comma-separated list of property names to retrieve (e.g. 'name,owner,description,sql_logic')"
        required: ["resource_uri", "properties_to_fetch"]

  - tool_spec:
      type: "generic"
      name: "euno_find_resource_by_name"
      description: "Find resources by name using fuzzy/similarity matching. Useful when you know the approximate name but not the exact URI."
      input_schema:
        type: "object"
        properties:
          resource_name:
            type: "string"
            description: "The name (or partial name) to search for"
          reasoning:
            type: "string"
            description: "Explain what you're looking for and why"
          filter_by_resource_types:
            type: "string"
            description: "Comma-separated list of types to filter by (e.g. 'table,dbt_model'). Leave empty for all types."
          properties_to_return:
            type: "string"
            description: "Comma-separated list of properties to include (e.g. 'name,owner,type'). Leave empty for default properties."
        required: ["resource_name", "reasoning", "filter_by_resource_types", "properties_to_return"]

  - tool_spec:
      type: "generic"
      name: "euno_find_resources_for_topic"
      description: "Find resources related to a topic using semantic search across names and descriptions. Best for discovering resources by business domain or purpose."
      input_schema:
        type: "object"
        properties:
          query_strings:
            type: "string"
            description: "Comma-separated list of query terms or phrases describing the topic (e.g. 'customer,revenue,churn')"
          reasoning:
            type: "string"
            description: "Explain what topic/domain you're exploring"
          filter_by_resource_types:
            type: "string"
            description: "Comma-separated list of types to filter by (e.g. 'table,view'). Leave empty for all types."
          properties_to_return:
            type: "string"
            description: "Comma-separated list of properties to include (e.g. 'name,description,owner'). Recommend including 'description' for context. Leave empty for defaults."
        required: ["query_strings", "reasoning", "filter_by_resource_types", "properties_to_return"]

  - tool_spec:
      type: "generic"
      name: "euno_get_upstream_lineage"
      description: "Get upstream lineage (dependencies) for a resource. Shows what tables, columns, or other resources the given resource depends on."
      input_schema:
        type: "object"
        properties:
          resource_uri:
            type: "string"
            description: "URI of the resource to trace lineage for"
          reasoning:
            type: "string"
            description: "Explain why you're tracing lineage and what you expect to find"
          properties_to_fetch:
            type: "string"
            description: "Comma-separated list of properties to retrieve for upstream resources (e.g. 'name,type,owner'). Leave empty for defaults."
          related_use_cases:
            type: "string"
            description: "Comma-separated list of related use case identifiers (e.g. 'TRACE_LINEAGE,DEBUG_ISSUE'). Leave empty if not applicable."
          filter_by_resource_types:
            type: "string"
            description: "Comma-separated list of resource types to filter by (e.g. 'table,column'). Leave empty for all types."
        required: ["resource_uri", "reasoning", "properties_to_fetch", "related_use_cases", "filter_by_resource_types"]

  - tool_spec:
      type: "generic"
      name: "euno_resource_impact_analysis"
      description: "Analyze the downstream impact of changes to a table or column. Shows dashboards, reports, and other resources that depend on this resource and would be affected by changes."
      input_schema:
        type: "object"
        properties:
          uri:
            type: "string"
            description: "URI of the table or column to analyze"
        required: ["uri"]

  - tool_spec:
      type: "generic"
      name: "euno_documentation_search"
      description: "Search Euno platform documentation for help with features, concepts, and usage guidelines."
      input_schema:
        type: "object"
        properties:
          query:
            type: "string"
            description: "What to search for in the documentation"
        required: ["query"]

  - tool_spec:
      type: "generic"
      name: "euno_documentation_get_full_document"
      description: "Retrieve the complete text of a documentation file by its URL."
      input_schema:
        type: "object"
        properties:
          url:
            type: "string"
            description: "URL of the documentation file to retrieve"
        required: ["url"]

  - tool_spec:
      type: "generic"
      name: "euno_documentation_get_surrounding_context"
      description: "Get chunks of documentation surrounding a specific chunk ID for more context."
      input_schema:
        type: "object"
        properties:
          chunk_id:
            type: "string"
            description: "ID of the documentation chunk to get context around"
          window_size:
            type: "number"
            description: "Number of chunks before and after to retrieve (default 1)"
        required: ["chunk_id", "window_size"]

tool_resources:
  euno_instructions:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_INSTRUCTIONS_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"

  euno_generate_eql_query:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_GENERATE_EQL_QUERY_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"

  euno_execute_eql_query:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_EXECUTE_EQL_QUERY_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"

  euno_execute_eql_count:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_EXECUTE_EQL_COUNT_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"

  euno_fetch_single_resource:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_FETCH_SINGLE_RESOURCE_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"

  euno_find_resource_by_name:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_FIND_RESOURCE_BY_NAME_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"

  euno_find_resources_for_topic:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_FIND_RESOURCES_FOR_TOPIC_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"

  euno_get_upstream_lineage:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_GET_UPSTREAM_LINEAGE_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"

  euno_resource_impact_analysis:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_RESOURCE_IMPACT_ANALYSIS_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"

  euno_documentation_search:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_DOCUMENTATION_SEARCH_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"

  euno_documentation_get_full_document:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_DOCUMENTATION_GET_FULL_DOCUMENT_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"

  euno_documentation_get_surrounding_context:
    type: "function"
    identifier: "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.EUNO_DOCUMENTATION_GET_SURROUNDING_CONTEXT_WRAPPER"
    execution_environment:
      type: "warehouse"
      warehouse: "${var.warehouse_name}"
  \$\$`;

    try {
      var stmt = snowflake.createStatement({sqlText: agentSQL});
      stmt.execute();
      return 'SUCCESS: Agent ${var.agent_name} created successfully!';
    } catch (err) {
      return 'ERROR: ' + err.message;
    }
  JS
  
  comment = "Creates the Euno agent - call this procedure once after terraform apply"
  
  depends_on = [
    snowflake_function.euno_instructions_wrapper,
    snowflake_function.euno_generate_eql_query_wrapper,
    snowflake_function.euno_execute_eql_query_wrapper,
    snowflake_function.euno_execute_eql_count_wrapper,
    snowflake_function.euno_fetch_single_resource_wrapper,
    snowflake_function.euno_find_resource_by_name_wrapper,
    snowflake_function.euno_find_resources_for_topic_wrapper,
    snowflake_function.euno_get_upstream_lineage_wrapper,
    snowflake_function.euno_resource_impact_analysis_wrapper,
    snowflake_function.euno_documentation_search_wrapper,
    snowflake_function.euno_documentation_get_full_document_wrapper,
    snowflake_function.euno_documentation_get_surrounding_context_wrapper,
  ]
}
