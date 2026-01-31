output "database_name" {
  description = "Name of the created Snowflake database"
  value       = snowflake_database.intelligence.name
}

output "schema_name" {
  description = "Name of the created Snowflake schema"
  value       = snowflake_schema.agents.name
}

output "api_integration_name" {
  description = "Name of the created API integration"
  value       = snowflake_api_integration.euno_mcp.name
}

output "network_rule_name" {
  description = "Name of the created network rule"
  value       = snowflake_network_rule.euno_api_gateway.name
}

output "next_steps" {
  description = "Instructions for completing the setup"
  value       = <<-EOT
    Terraform has created the database, schema, network rule, API integration, and external functions.
    
    To complete the setup, run the following SQL files in order:
    1. wrapper_functions.sql - Creates wrapper functions for type safety
    2. agent_definition.sql - Creates the Snowflake Agent
    3. permissions.sql - Sets up roles and permissions
    
    You can generate these files from the templates using:
    - Replace ${DATABASE_NAME} with: ${snowflake_database.intelligence.name}
    - Replace ${SCHEMA_NAME} with: ${snowflake_schema.agents.name}
    - Replace ${AGENT_NAME} with: ${var.agent_name}
    - Replace ${ROLE_NAME} with: ${var.role_name}
    - Replace ${WAREHOUSE_NAME} with: ${var.warehouse_name}
    - Replace ${API_INTEGRATION_NAME} with: ${snowflake_api_integration.euno_mcp.name}
    - Replace ${ORCHESTRATION_MODEL} with: ${var.orchestration_model}
    - Replace ${BUDGET_SECONDS} with: ${var.agent_budget_seconds}
    - Replace ${BUDGET_TOKENS} with: ${var.agent_budget_tokens}
    - Replace ${AGENT_DISPLAY_NAME} with: ${var.agent_display_name}
    - Replace ${AGENT_AVATAR} with: ${var.agent_avatar}
    - Replace ${AGENT_COLOR} with: ${var.agent_color}
  EOT
}
