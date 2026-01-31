# Terraform Euno Snowflake Intelligence Module

This Terraform module installs the Euno AI agent into your Snowflake Intelligence environment, enabling natural language querying and analysis of your data pipeline metadata.

## Overview

The Euno AI agent provides:
- **Natural language search** across your data pipeline resources
- **Lineage tracking** to understand data dependencies
- **Impact analysis** for change management
- **Documentation search** for Euno platform features
- **Semantic queries** to discover resources by business domain

## Architecture

This module creates:
1. **Database and Schema** - `SNOWFLAKE_INTELLIGENCE.AGENTS` by default
2. **Network Rule** - Allows egress to Euno API Gateway
3. **API Integration** - Configures Google API Gateway authentication
4. **External Functions** - 11 functions for interacting with Euno API
5. **Wrapper Functions** - Type-safe SQL wrappers (via SQL template)
6. **Snowflake Agent** - AI agent powered by Claude (via SQL template)
7. **Roles and Permissions** - Access control setup (via SQL template)

## Prerequisites

- Snowflake account with `ACCOUNTADMIN` role access
- Terraform >= 1.5.0
- Euno API credentials (API key and Account ID)
- Snowflake compute warehouse (default: `CORE`)

## Usage

### Basic Example

```hcl
module "euno_agent" {
  source = "github.com/euno-ai/terraform-euno-snowflake-intelligence"

  euno_api_key    = var.euno_api_key
  euno_account_id = var.euno_account_id
}
```

### Complete Example

```hcl
module "euno_agent" {
  source = "github.com/euno-ai/terraform-euno-snowflake-intelligence"

  # Required: Euno credentials
  euno_api_key    = var.euno_api_key
  euno_account_id = var.euno_account_id

  # Optional: Snowflake configuration
  database_name   = "SNOWFLAKE_INTELLIGENCE"
  schema_name     = "AGENTS"
  warehouse_name  = "CORE"
  agent_name      = "EUNO_AGENT"
  role_name       = "EUNO_AGENT_USER"

  # Optional: Agent configuration
  orchestration_model  = "claude-sonnet-4-5"
  agent_budget_seconds = 300
  agent_budget_tokens  = 160000
  agent_display_name   = "Euno.ai Agent"
  agent_avatar         = "CirclesAgentIcon"
  agent_color          = "orange"

  # Optional: Grant role to users
  grant_role_to_users = ["user1@example.com", "user2@example.com"]
}
```

## Installation Steps

1. **Run Terraform**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

2. **Apply SQL Templates**:
   After Terraform completes, you need to run three SQL scripts in order:

   a. **Generate wrapper functions SQL**:
   ```bash
   # Replace template variables
   sed -e "s/\${DATABASE_NAME}/SNOWFLAKE_INTELLIGENCE/g" \
       -e "s/\${SCHEMA_NAME}/AGENTS/g" \
       wrapper_functions.sql.tpl > wrapper_functions.sql
   ```

   b. **Generate agent definition SQL**:
   ```bash
   sed -e "s/\${DATABASE_NAME}/SNOWFLAKE_INTELLIGENCE/g" \
       -e "s/\${SCHEMA_NAME}/AGENTS/g" \
       -e "s/\${AGENT_NAME}/EUNO_AGENT/g" \
       -e "s/\${WAREHOUSE_NAME}/CORE/g" \
       -e "s/\${ORCHESTRATION_MODEL}/claude-sonnet-4-5/g" \
       -e "s/\${BUDGET_SECONDS}/300/g" \
       -e "s/\${BUDGET_TOKENS}/160000/g" \
       -e "s/\${AGENT_DISPLAY_NAME}/Euno.ai Agent GW/g" \
       -e "s/\${AGENT_AVATAR}/CirclesAgentIcon/g" \
       -e "s/\${AGENT_COLOR}/orange/g" \
       agent_definition.sql.tpl > agent_definition.sql
   ```

   c. **Generate permissions SQL**:
   ```bash
   sed -e "s/\${DATABASE_NAME}/SNOWFLAKE_INTELLIGENCE/g" \
       -e "s/\${SCHEMA_NAME}/AGENTS/g" \
       -e "s/\${AGENT_NAME}/EUNO_AGENT/g" \
       -e "s/\${ROLE_NAME}/EUNO_AGENT_USER/g" \
       -e "s/\${WAREHOUSE_NAME}/CORE/g" \
       -e "s/\${API_INTEGRATION_NAME}/euno_mcp_api_integration/g" \
       permissions.sql.tpl > permissions.sql
   ```

   d. **Execute the SQL files** in your Snowflake account:
   ```sql
   -- In Snowflake worksheet or CLI
   !source wrapper_functions.sql
   !source agent_definition.sql
   !source permissions.sql
   ```

3. **Grant Access to Users**:
   ```sql
   GRANT ROLE EUNO_AGENT_USER TO USER your_username;
   ```

## Why SQL Templates?

The Terraform Snowflake provider has limitations with complex SQL constructs like:
- Wrapper functions with inline SQL logic
- Agent definitions with YAML specifications
- Complex permission grants

These are provided as SQL templates that you can customize and apply after the Terraform infrastructure is created.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| euno_api_key | Euno API key for authentication | string | - | yes |
| euno_account_id | Euno account ID | string | - | yes |
| database_name | Database name | string | "SNOWFLAKE_INTELLIGENCE" | no |
| schema_name | Schema name | string | "AGENTS" | no |
| warehouse_name | Warehouse name | string | "CORE" | no |
| agent_name | Agent name | string | "EUNO_AGENT" | no |
| role_name | Role name | string | "EUNO_AGENT_USER" | no |
| api_gateway_host | API Gateway host | string | "euno-mcp-gateway-dev-7a33ocyx.uc.gateway.dev" | no |
| orchestration_model | Agent orchestration model | string | "claude-sonnet-4-5" | no |
| agent_budget_seconds | Max execution time (seconds) | number | 300 | no |
| agent_budget_tokens | Max tokens | number | 160000 | no |
| grant_role_to_users | Users to grant role to | list(string) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| database_name | Created database name |
| schema_name | Created schema name |
| api_integration_name | Created API integration name |
| network_rule_name | Created network rule name |
| next_steps | Instructions for completing setup |

## Using the Agent

Once installed, you can interact with the Euno agent in Snowflake:

```sql
-- Switch to the agent role
USE ROLE EUNO_AGENT_USER;

-- Query the agent
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'EUNO_AGENT',
  'Show me all tables in the analytics schema'
);
```

## Migration from Manual Setup

If you previously used the manual SQL setup (`snowflake-setup-external-functions.sql`), this module provides the same functionality with:
- **Infrastructure as Code** - Version controlled and repeatable
- **Parameterization** - Easy to customize for different environments
- **Best practices** - Follows Terraform and Snowflake conventions

## Security Considerations

- API keys and account IDs are marked as sensitive
- Store credentials in Terraform variables or secrets management
- Use Terraform state encryption
- Limit role grants to necessary users only

## Support

For issues or questions:
- Euno Documentation: https://docs.euno.ai
- GitHub Issues: https://github.com/euno-ai/terraform-euno-snowflake-intelligence/issues
- Email: support@euno.ai

## License

Apache 2.0 - See LICENSE file for details
