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
5. **Wrapper Functions** - Type-safe SQL wrappers (created by Terraform!)
6. **Role and Permissions** - Complete access control setup
7. **Agent SQL File** - Generated SQL for creating the Snowflake Agent

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

### 1. Run Terraform

```bash
terraform init
terraform plan
terraform apply
```

Terraform will create:
- ✅ Database and schema
- ✅ Network rule and API integration
- ✅ 11 external functions
- ✅ 11 wrapper functions (with type safety!)
- ✅ Role and all permissions
- ✅ Generated agent SQL file

### 2. Create the Snowflake Agent

After `terraform apply` completes, you'll find a file called `generated_agent.sql` in your module directory.

**Option A: Using SnowSQL CLI**
```bash
snowsql -f generated_agent.sql
```

**Option B: Using Snowflake Worksheet**
1. Open Snowflake web UI
2. Create a new SQL worksheet
3. Copy the contents of `generated_agent.sql`
4. Paste and execute

**Option C: Using Terraform Output**
```bash
terraform output -raw agent_sql_file | xargs snowsql -f
```

### 3. Grant Agent Usage to Role

```sql
GRANT USAGE ON AGENT EUNO_AGENT TO ROLE EUNO_AGENT_USER;
```

### 4. Grant Role to Users (if not done in Terraform)

```sql
GRANT ROLE EUNO_AGENT_USER TO USER your_username;
```

## Why Can't Terraform Create the Agent?

The Snowflake Terraform provider (as of v0.98) doesn't yet have a resource for Snowflake Intelligence Agents. This is because:
- Agents are a very new Snowflake feature (released in late 2024)
- The provider is still adding support for newer Snowflake features
- Agent definitions use complex YAML specifications that don't map well to HCL

**Solution**: Terraform generates the SQL for you! You just need to run one SQL file after `terraform apply`.

**Good news**: Everything else (functions, permissions, roles) IS created by Terraform automatically!

## What's Automated vs Manual

| Component | Status | Notes |
|-----------|--------|-------|
| Database & Schema | ✅ Automated | Created by Terraform |
| Network Rules | ✅ Automated | Created by Terraform |
| API Integration | ✅ Automated | Created by Terraform |
| External Functions (11) | ✅ Automated | Created by Terraform |
| Wrapper Functions (11) | ✅ Automated | Created by Terraform |
| Role Creation | ✅ Automated | Created by Terraform |
| Permissions | ✅ Automated | Granted by Terraform |
| Agent Creation | ⚠️  Manual | Run generated SQL file |
| Agent Usage Grant | ⚠️  Manual | Simple one-line SQL |

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
| agent_display_name | Agent display name | string | "Euno.ai Agent GW" | no |
| agent_avatar | Agent avatar icon | string | "CirclesAgentIcon" | no |
| agent_color | Agent color theme | string | "orange" | no |
| grant_role_to_users | Users to grant role to | list(string) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| database_name | Created database name |
| schema_name | Created schema name |
| api_integration_name | Created API integration name |
| network_rule_name | Created network rule name |
| role_name | Created role name |
| agent_sql_file | Path to generated agent SQL file |
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
- **99% Automation** - Only agent creation requires manual SQL execution
- **Infrastructure as Code** - Version controlled and repeatable
- **Parameterization** - Easy to customize for different environments
- **Best practices** - Follows Terraform and Snowflake conventions

## Troubleshooting

### "Function already exists" errors
If you previously ran the manual SQL setup, you may see errors about existing resources. Use `terraform import` to bring them under Terraform management, or drop them manually first.

### Permission denied errors
Ensure you're running Terraform with a Snowflake user that has `ACCOUNTADMIN` privileges.

### Agent SQL file not found
The file is generated in the same directory where you run Terraform. Check the `agent_sql_file` output for the exact path.

## Support

For issues or questions:
- Euno Documentation: https://docs.euno.ai
- GitHub Issues: https://github.com/euno-ai/terraform-euno-snowflake-intelligence/issues
- Email: support@euno.ai

## License

Apache 2.0 - See LICENSE file for details
