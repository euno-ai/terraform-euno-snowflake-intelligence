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

output "agent_sql_file" {
  description = "Path to the generated agent SQL file"
  value       = local_file.agent_sql.filename
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
    
    📋 To complete the setup:
    
    1. Apply the generated agent SQL:
       snowsql -f ${local_file.agent_sql.filename}
       
       OR copy/paste the contents of ${local_file.agent_sql.filename} into a Snowflake worksheet
    
    2. Grant agent usage to the role (after agent is created):
       GRANT USAGE ON AGENT ${var.agent_name} TO ROLE ${var.role_name};
    
    3. Grant the role to users:
       GRANT ROLE ${var.role_name} TO USER <username>;
    
    🎉 Once complete, users can interact with the agent using Snowflake Cortex!
  EOT
}
