terraform {
  required_version = ">= 1.5.0"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.98"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
