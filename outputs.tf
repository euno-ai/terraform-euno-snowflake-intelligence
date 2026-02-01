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

output "role_name" {
  description = "Name of the created role for agent users"
  value       = snowflake_role.euno_agent_user.name
}

output "create_agent_procedure" {
  description = "Name of the procedure to call to create the agent"
  value       = "${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_procedure_javascript.create_euno_agent.name}()"
}

output "next_steps" {
  description = "Instructions for completing the setup"
  value       = <<-EOT
    ✅ Terraform has successfully created:
    - Database: ${snowflake_database.intelligence.name}
    - Schema: ${snowflake_schema.agents.name}
    - Network rule and API integration
    - 11 external functions
    - 11 wrapper functions (with type safety)
    - Role: ${snowflake_role.euno_agent_user.name}
    - All necessary permissions
    - Agent creation procedure ✨
    
    📋 To complete the setup (2 simple SQL commands):
    
    1. Create the agent by calling the procedure:
       CALL ${snowflake_database.intelligence.name}.${snowflake_schema.agents.name}.${snowflake_procedure_javascript.create_euno_agent.name}();
    
    2. Grant agent usage to the role:
       GRANT USAGE ON AGENT ${var.agent_name} TO ROLE ${var.role_name};
    
    Optional - Grant the role to specific users:
       GRANT ROLE ${var.role_name} TO USER <username>;
    
    🎉 That's it! Users can now interact with the agent using Snowflake Cortex!
  EOT
}
