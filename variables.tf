variable "name" {
  description = "The diagnostic setting name"
  type        = string
  validation {
    condition     = var.name != "service"
    error_message = "Do not use service as the diagnostic setting name as it impacts legacy API support"
  }
}

variable "target_resource_id" {
  description = "The resource ID of the resource to enable diagnostic settings for"
  type        = string
}

variable "eventhub_name" {
  description = "The destination eventhub"
  default     = null
  type        = string
}

variable "eventhub_authorization_rule_id" {
  description = "The resource ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data"
  default     = null
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The destiation log analytics workspace"
  default     = null
  type        = string
}

variable "log_analytics_destination_type" {
  description = "Resource specific tables or legacy AzureDiagnostics table"
  default     = null
  type        = string
  validation {
    condition     = var.log_analytics_destination_type == null || can(index(["Dedicated", "AzureDiagnostics"], var.log_analytics_destination_type) > 0)
    error_message = "If populated the destination type must be Dedicated or AzureDiagnostics"
  }
}

variable "log_category" {
  description = "A list of log categories"
  default     = []
  type        = list(string)
}

variable "logs" {
  description = "A list of log types"
  default     = []
  type        = list(string)
  validation {
    condition     = (length(var.log_category) > 0 && length(var.logs) == 0) || (length(var.log_category) == 0 && length(var.logs) > 0)
    error_message = "Only pass values to either log_category or logs"
  }
}

variable "metrics" {
  description = "A map of diagnostic metrics to forward"
  default     = []
  type        = list(string)
}

variable "storage_account_id" {
  description = "The destination storage account"
  default     = null
  type        = string
  validation {
    condition     = var.eventhub_authorization_rule_id != null || var.log_analytics_workspace_id != null || var.storage_account_id != null
    error_message = "You must provide one of Eventhub rule Id, Log Analytics Workspace Id, or Storage Account Id"
  }
}