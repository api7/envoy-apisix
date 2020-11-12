local core = require("apisix.core")
local plugin = require("apisix.core.plugin")
local ctx = {}

function envoy_on_request(request_handle)
  core.ctx.set_vars_meta(ctx, request_handle)

  local metadata = request_handle:metadata()
  local plugins = metadata:get("plugins")

  ctx.phase = "request"
  ctx.handle = request_handle

  core.plugin.run(ctx, plugins)

--   local plugin_name = ""
--   if #plugins > 0 then
--       for key, plugin_conf in pairs(plugins) do
--         plugin_name = plugin_conf.name
--         request_handle:logWarn("plugin name:" .. plugin_conf.name .. " key: " .. key)
--       end
--   end

--   local ok, redirect = pcall(require, "apisix.plugins.redirect")
--   local phase_func = redirect.rewrite
--   local conf = {ret_code = 302, uri = "/redirected/path-" .. plugin_name}
--   phase_func(conf, ctx, request_handle)
end

function envoy_on_response(response_handle)
    local metadata = response_handle:metadata()
    local plugins = metadata:get("plugins")
  
    ctx.phase = "response"
    ctx.handle = response_handle
  
    core.plugin.run(ctx, plugins)
end