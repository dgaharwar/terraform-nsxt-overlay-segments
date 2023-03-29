# Input Variables
locals {
  nsxt_config                        = yamldecode(file("${path.module}/nsxt-config.yaml"))
  overlay_segments                   = local.nsxt_config.overlay_segments
  overlay_tz_path                    = data.nsxt_policy_transport_zone.overlay_tz.path
  target_tier1_gateway_name          = "t1-operations"
  overlay_target_transport_zone_name = "nsx-overlay-transportzone"
}

# data block that reads from the datasource (transport zone)
data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name                       = local.overlay_target_transport_zone_name
}

# module that deploys overlay segments
module "overlay_segments" {
  source                             = "github.com/kalenarndt/terraform-nsxt-overlay-segments"
  overlay_segments                   = local.overlay_segments
  tier1_gateway_path                 = local.tier1_gateway_paths[local.target_tier1_gateway_name]
  transport_zone_path                = local.overlay_tz_path
}


# Computed Locals
# Modified object outputs from modules to be referenced by others. 
locals {
  tier1_gateway_objs                 = module.tier1_gateway.tier1_gateways
  tier1_gateway_paths                = { for gw_name, gateway in local.tier1_gateway_objs : (gw_name) => gateway.path }
}
