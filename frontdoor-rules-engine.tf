resource "azurerm_frontdoor_rules_engine" "example_rules_engine" {
  name                = "exampleRulesEngineConfig1"
  frontdoor_name      = azurerm_frontdoor.fd_express_api.name
  resource_group_name = azurerm_frontdoor.fd_express_api.resource_group_name

  rule {
    name     = "debuggingoutput"
    priority = 1

    action {
      response_header {
        header_action_type = "Append"
        header_name        = "X-TEST-HEADER"
        value              = "Append Header Rule"
      }
    }
  }

  rule {
    name     = "NoSeDkTraffic"
    priority = 69

    match_condition {
      variable = "RemoteAddr"
      operator = "GeoMatch"
      value    = ["NO", "SE", "DK"]
    }

    action {
      response_header {
        header_action_type = "Overwrite"
        header_name        = "X-Picccard-Test"
        value              = "scandic-client"
      }
    }
  }
}


resource "null_resource" "fd_routing_route1" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    # command = "az network front-door routing-rule update --front-door-name  --resource-group RESOURCE_GROUP --name ROUTING_NAME --rules-engine ENGINE_NAME"
    # command = "az config set extension.use_dynamic_install=yes_without_prompt && az network front-door routing-rule update --front-door-name NAME --resource-group RESOURCE_GROUP --name ROUTING_NAME --rules-engine ENGINE_NAME"

    command = <<CMD
      az extension add --name front-door --yes && \
      az network front-door routing-rule update \
      --front-door-name ${azurerm_frontdoor_rules_engine.example_rules_engine.frontdoor_name} \
      --resource-group ${azurerm_frontdoor_rules_engine.example_rules_engine.resource_group_name} \
      --name "exampleRoutingRule1" \
      --rules-engine ${azurerm_frontdoor_rules_engine.example_rules_engine.name}
    CMD
  } # # azurerm_frontdoor.fd_express_api.routing_rule[0].name # exampleRoutingRule1
  # forces execution to go after front door and rules engine
  depends_on = [
    azurerm_frontdoor.fd_express_api,
    azurerm_frontdoor_rules_engine.example_rules_engine
  ]
}