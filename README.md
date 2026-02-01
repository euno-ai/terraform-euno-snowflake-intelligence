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
4. **External Functions** - 12 functions for interacting with Euno v2 API
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
- ✅ 12 external functions (v2 API)
- ✅ 12 wrapper functions (with type safety!)
- ✅ Role and all permissions
- ✅ **Agent creation procedure** (the smart way!)

### 2. Create the Agent (Just Call a Procedure!)

After `terraform apply`, run these two SQL commands in Snowflake:

```sql
-- 1. Create the agent
CALL SNOWFLAKE_INTELLIGENCE.AGENTS.CREATE_EUNO_AGENT();

-- 2. Grant usage to the role
GRANT USAGE ON AGENT EUNO_AGENT TO ROLE EUNO_AGENT_USER;
```

**That's it!** No SQL files to copy/paste, no manual editing. Terraform created a procedure that does all the work.

### 3. (Optional) Grant Role to Users

If you didn't specify `grant_role_to_users` in Terraform:

```sql
GRANT ROLE EUNO_AGENT_USER TO USER your_username;
```

## Why Use a Procedure Instead of Native Terraform?

The Snowflake Terraform provider (as of v0.98) doesn't have a `snowflake_agent` resource yet because:
- Agents are brand new (late 2024 feature)
- Provider is still catching up with new Snowflake features
- [GitHub Issue #4264](https://github.com/snowflakedb/terraform-provider-snowflake/issues/4264) tracks this

**Our Solution**: Terraform creates a **stored procedure** that creates the agent!
- ✅ Procedure is created by Terraform
- ✅ You just call the procedure - no SQL files to manage
- ✅ All agent configuration is templated from Terraform variables
- ✅ Cleaner than running SQL files manually

This is the smartest workaround until Snowflake adds native support!

## What's Automated vs Manual

| Component | Status | Notes |
|-----------|--------|-------|
| Database & Schema | ✅ Fully Automated | Created by Terraform |
| Network Rules | ✅ Fully Automated | Created by Terraform |
| API Integration | ✅ Fully Automated | Created by Terraform |
| External Functions (12) | ✅ Fully Automated | Created by Terraform (v2 API) |
| Wrapper Functions (12) | ✅ Fully Automated | Created by Terraform |
| Role Creation | ✅ Fully Automated | Created by Terraform |
| Permissions | ✅ Fully Automated | Granted by Terraform |
| **Agent Procedure** | ✅ Fully Automated | **Created by Terraform!** |
| Agent Creation | ⚠️ One SQL Call | `CALL procedure()` |
| Agent Usage Grant | ⚠️ One SQL Call | `GRANT USAGE...` |

**99.9% automated!** Just 2 simple SQL commands after `terraform apply`.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| euno_api_key | Euno API key for authentication | string | - | yes |
| euno_account_id | Euno account ID | string | - | yes |
| database_name | Database name | string | "SNOWFLAKE_INTELLIGENCE" | no |
| schema_name | Schema name | string | "AGENTS" | no |
| warehouse_name | Warehouse name | string | n/a | **yes** |
| agent_name | Agent name | string | "EUNO_AGENT" | no |
| role_name | Role name | string | "EUNO_AGENT_USER" | no |
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
## Support

For issues or questions:
- Euno Documentation: https://docs.euno.ai
- GitHub Issues: https://github.com/euno-ai/terraform-euno-snowflake-intelligence/issues
- Email: support@euno.ai

## License

MIT - See LICENSE file for details
