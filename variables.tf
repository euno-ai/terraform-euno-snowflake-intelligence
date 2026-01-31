variable "euno_api_key" {
  description = "Euno API key for authentication"
  type        = string
  sensitive   = true
}

variable "euno_account_id" {
  description = "Euno account ID for authentication"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Snowflake database name where the agent will be installed"
  type        = string
  default     = "SNOWFLAKE_INTELLIGENCE"
}

variable "schema_name" {
  description = "Snowflake schema name where the agent will be installed"
  type        = string
  default     = "AGENTS"
}

variable "warehouse_name" {
  description = "Snowflake warehouse name for executing agent functions"
  type        = string
  default     = "CORE"
}

variable "agent_name" {
  description = "Name of the Snowflake agent to create"
  type        = string
  default     = "EUNO_AGENT"
}

variable "role_name" {
  description = "Name of the Snowflake role for agent users"
  type        = string
  default     = "EUNO_AGENT_USER"
}

variable "api_gateway_host" {
  description = "Euno API Gateway host (without https://)"
  type        = string
  default     = "euno-mcp-gateway-dev-7a33ocyx.uc.gateway.dev"
}

variable "api_gateway_audience" {
  description = "Google API Gateway audience URL"
  type        = string
  default     = "https://euno-mcp-gateway-dev-7a33ocyx.uc.gateway.dev"
}

variable "network_rule_name" {
  description = "Name of the network rule for API Gateway"
  type        = string
  default     = "euno_api_gateway_network_rule"
}

variable "api_integration_name" {
  description = "Name of the API integration"
  type        = string
  default     = "euno_mcp_api_integration"
}

variable "orchestration_model" {
  description = "Model to use for agent orchestration"
  type        = string
  default     = "claude-sonnet-4-5"
}

variable "agent_budget_seconds" {
  description = "Maximum execution time for agent in seconds"
  type        = number
  default     = 300
}

variable "agent_budget_tokens" {
  description = "Maximum tokens for agent execution"
  type        = number
  default     = 160000
}

variable "agent_display_name" {
  description = "Display name for the agent in Snowflake UI"
  type        = string
  default     = "Euno.ai Agent GW"
}

variable "agent_avatar" {
  description = "Avatar icon for the agent"
  type        = string
  default     = "CirclesAgentIcon"
}

variable "agent_color" {
  description = "Color theme for the agent"
  type        = string
  default     = "orange"
}

variable "grant_role_to_users" {
  description = "List of Snowflake users to grant the agent role to"
  type        = list(string)
  default     = []
}
