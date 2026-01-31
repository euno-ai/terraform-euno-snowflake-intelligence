-- This file should be applied after running `terraform apply`, wrapper_functions.sql, and agent_definition.sql
-- Replace template variables with your actual values

USE DATABASE ${DATABASE_NAME};
USE SCHEMA ${SCHEMA_NAME};

CREATE ROLE IF NOT EXISTS ${ROLE_NAME};
GRANT ROLE ${ROLE_NAME} TO ROLE ACCOUNTADMIN;
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE ${ROLE_NAME};
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE ACCOUNTADMIN;

GRANT USAGE ON DATABASE ${DATABASE_NAME} TO ROLE ${ROLE_NAME};
GRANT USAGE ON SCHEMA ${DATABASE_NAME}.${SCHEMA_NAME} TO ROLE ${ROLE_NAME};
GRANT USAGE ON AGENT ${AGENT_NAME} TO ROLE ${ROLE_NAME};

-- Grant usage on all external functions (required by wrapper functions)
GRANT USAGE ON FUNCTION euno_instructions(VARIANT) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_count_resources(VARIANT, VARIANT, VARIANT, VARIANT, VARIANT) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_fetch_single_resource(VARIANT, VARIANT) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_find_resource_by_name(VARIANT, VARIANT, VARIANT, VARIANT) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_find_resources_for_topic(VARIANT, VARIANT, VARIANT, VARIANT) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_get_upstream_lineage(VARIANT, VARIANT, VARIANT, VARIANT, VARIANT) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_resource_impact_analysis(VARIANT) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_search_resources(VARIANT, VARIANT, VARIANT, VARIANT, VARIANT, VARIANT, VARIANT) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_documentation_search(VARIANT) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_documentation_get_full_document(VARIANT) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_documentation_get_surrounding_context(VARIANT, VARIANT) TO ROLE ${ROLE_NAME};

-- Grant usage on wrapper functions (used by agent)
GRANT USAGE ON FUNCTION euno_instructions_wrapper(NUMBER) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_count_resources_wrapper(STRING, STRING, STRING, STRING, STRING) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_fetch_single_resource_wrapper(STRING, STRING) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_find_resource_by_name_wrapper(STRING, STRING, STRING, STRING) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_find_resources_for_topic_wrapper(STRING, STRING, STRING, STRING) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_get_upstream_lineage_wrapper(STRING, STRING, STRING, STRING, STRING) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_resource_impact_analysis_wrapper(STRING) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_search_resources_wrapper(STRING, STRING, STRING, STRING, STRING, STRING, STRING) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_documentation_search_wrapper(STRING) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_documentation_get_full_document_wrapper(STRING) TO ROLE ${ROLE_NAME};
GRANT USAGE ON FUNCTION euno_documentation_get_surrounding_context_wrapper(STRING, NUMBER) TO ROLE ${ROLE_NAME};
GRANT USAGE ON WAREHOUSE ${WAREHOUSE_NAME} TO ROLE ${ROLE_NAME};

-- Grant usage on integration
GRANT USAGE ON INTEGRATION ${API_INTEGRATION_NAME} TO ROLE ${ROLE_NAME};

-- Grant the agent user role to specific users (replace with actual usernames)
-- GRANT ROLE ${ROLE_NAME} TO USER your_user_name_here;
