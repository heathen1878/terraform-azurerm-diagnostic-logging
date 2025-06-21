data "azurerm_monitor_diagnostic_categories" "this" {
  resource_id = var.target_resource_id
}

locals {
  log_categories = length(var.log_category) == 0 ? [] : contains(var.log_category, "All") ? data.azurerm_monitor_diagnostic_categories.this.log_category_groups : var.log_category
  logs           = length(var.logs) == 0 ? [] : contains(var.logs, "All") ? data.azurerm_monitor_diagnostic_categories.this.log_category_types : var.logs
  metrics        = length(var.metrics) == 0 ? [] : contains(var.metrics, "All") ? data.azurerm_monitor_diagnostic_categories.this.metrics : var.metrics
}