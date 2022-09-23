# resource "azurerm_resource_group" "example" {
#   name     = "example-cdn-frontdoor"
#   location = "West Europe"
# }

# resource "azurerm_cdn_frontdoor_profile" "example" {
#   name                = "example-profile-eula"
#   resource_group_name = azurerm_resource_group.example.name
#   sku_name            = "Standard_AzureFrontDoor"
# }

# resource "azurerm_cdn_frontdoor_endpoint" "example" {
#   name                     = "example-endpoint-eula"
#   cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id

#   tags = {
#     endpoint = "contoso.com"
#   }
# }

# resource "azurerm_cdn_frontdoor_origin_group" "example" {
#   name                     = "example-originGroup-eula"
#   cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
#   session_affinity_enabled = false

#   # restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10

#   health_probe {
#     interval_in_seconds = 240
#     path                = "/health"
#     protocol            = "Https"
#     request_type        = "GET"
#   }

#   load_balancing {
#   #  additional_latency_in_milliseconds = 0
#   #  sample_size                        = 16
#   #  successful_samples_required        = 3
#   }
# }

# resource "azurerm_cdn_frontdoor_origin" "example" {
#   name                          = "example-origin"
#   cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.example.id

#   health_probes_enabled          = true
#   certificate_name_check_enabled = false

#   host_name          = module.appservice1.webapp_default_hostname
#   origin_host_header = module.appservice1.webapp_default_hostname
#   http_port          = 80
#   https_port         = 443
#   priority           = 1
#   weight             = 50
# }

# resource "azurerm_cdn_frontdoor_rule_set" "example" {
#   name                     = "exampleruleset"
#   cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
# }

# resource "azurerm_cdn_frontdoor_rule" "example" {
#   depends_on = [azurerm_cdn_frontdoor_origin_group.example, azurerm_cdn_frontdoor_origin.example]

#   name                      = "examplerule"
#   cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.example.id
#   order                     = 1
#   behavior_on_match         = "Continue"

#   actions {
#     route_configuration_override_action {
#       cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.example.id
#       forwarding_protocol           = "HttpsOnly"
#       query_string_caching_behavior = "IncludeSpecifiedQueryStrings"
#       query_string_parameters       = ["foo", "clientIp={client_ip}"]
#       compression_enabled           = true
#       cache_behavior                = "OverrideIfOriginMissing"
#       cache_duration                = "365.23:59:59"
#     }

#     url_redirect_action {
#       redirect_type        = "PermanentRedirect"
#       redirect_protocol    = "MatchRequest"
#       query_string         = "clientIp={client_ip}"
#       destination_path     = "/exampleredirection"
#       destination_hostname = "contoso.com"
#       destination_fragment = "UrlRedirect"
#     }
#   }

#   conditions {
#     host_name_condition {
#       operator         = "Equal"
#       negate_condition = false
#       match_values     = ["www.contoso.com", "images.contoso.com", "video.contoso.com"]
#       transforms       = ["Lowercase", "Trim"]
#     }

#     is_device_condition {
#       operator         = "Equal"
#       negate_condition = false
#       match_values     = ["Mobile"]
#     }

#     post_args_condition {
#       post_args_name = "customerName"
#       operator       = "BeginsWith"
#       match_values   = ["J", "K"]
#       transforms     = ["Uppercase"]
#     }

#     request_method_condition {
#       operator         = "Equal"
#       negate_condition = false
#       match_values     = ["DELETE"]
#     }

#     url_filename_condition {
#       operator         = "Equal"
#       negate_condition = false
#       match_values     = ["media.mp4"]
#       transforms       = ["Lowercase", "RemoveNulls", "Trim"]
#     }
#   }
# }