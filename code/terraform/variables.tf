# Define the Resource Group name
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-chaos-engineering-lab"
}

# Define the Azure Region for all resources
variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "germanywestcentral"
}

# Define the Project Name prefix for naming consistency
variable "project_name" {
  description = "Prefix for resource names"
  type        = string
  default     = "chaos-lab"
}

# Define the tags for resource governance
variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default = {
    Environment = "Dev"
    Project     = "ChaosEngineering"
    Tool        = "Terraform"
  }
}
