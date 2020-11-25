local core = require("apisix.core")
local ctx = {}

function envoy_on_request(request_handle)
  core.ctx.set_vars_meta(ctx, request_handle)

  local metadata = request_handle:metadata()
  local plugins = metadata:get("plugins")

  ctx.phase = "request"
  ctx.handle = request_handle

  core.plugin.run(ctx, plugins)
end

function envoy_on_response(response_handle)
    local metadata = response_handle:metadata()
    local plugins = metadata:get("plugins")
  
    ctx.phase = "response"
    ctx.handle = response_handle
  
    core.plugin.run(ctx, plugins)
end