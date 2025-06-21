resource "azurerm_monitor_diagnostic_setting" "this" {
  name                           = var.name
  target_resource_id             = var.target_resource_id
  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type
  storage_account_id             = var.storage_account_id

  dynamic "enabled_log" {
    for_each = local.logs

    content {
      category = enabled_log.value

      retention_policy {
        days    = 0
        enabled = false
      }
    }
  }

  dynamic "enabled_log" {
    for_each = local.log_categories

    content {
      category_group = enabled_log.value

      retention_policy {
        days    = 0
        enabled = false
      }
    }
  }

  dynamic "metric" {
    for_each = sort(data.azurerm_monitor_diagnostic_categories.this.metrics)

    content {
      category = metric.value
      enabled  = contains(local.metrics, metric.value) ? true : false

      retention_policy {
        days    = 0
        enabled = false
      }
    }
  }
}